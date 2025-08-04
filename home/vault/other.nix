{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.campground; let
  cfg = config.campground.services.vault;

  package =
    if cfg.ui
    then pkgs.vault-bin
    else pkgs.vault;

  has-policies = (builtins.length (builtins.attrNames cfg.policies)) != 0;

  format-policy = name: file:
    pkgs.runCommandNoCC "formatted-vault-policy"
    {
      inherit file;
      buildInputs = [package];
    } ''
      name="$(basename "$file")"

      cp "$file" "./$name"

      # Ensure that vault can overwrite the file.
      chmod +w "./$name"

      # Create this variable here to avoid swallowing vault's exit code.
      vault_output=

      set +e
      vault_output=$(vault policy fmt "./$name" 2>&1)
      vault_status=$?
      set -e

      if [ "$vault_status" != 0 ]; then
        echo 'Error formatting policy "${name}"'
        echo "This is normally caused by a syntax error in the policy file."
        echo "$file"
        echo ""
        echo "Vault Output:"
        echo "$vault_output"
        exit 1
      fi

      mv "./$name" $out
    '';

  policies =
    mapAttrs
    (name: value:
      if builtins.isPath value
      then format-policy name value
      else format-policy name (pkgs.writeText "${name}.hcl" value))
    cfg.policies;

  unseal-script = pkgs.writeShellApplication {
    name = "celvis-unseal-vault";
    runtimeInputs = [package pkgs.clevis pkgs.curl];
    text = ''
      # TODO: make sure this exists?
      export HOME="/var/lib/vault" # Needed or Vault cli shits the bed
      # Path to the encrypted file containing the unseal key
      encrypted_file="${cfg.tang-unseal-key}"

      # Vault address (e.g., local or cluster address)
      export VAULT_ADDR="http://127.0.0.1:8200"
      unseal_key=$(${pkgs.clevis}/bin/clevis decrypt < "$encrypted_file")
      if [ -z "$unseal_key" ]; then
          echo "Error: Failed to decrypt the unseal key. Proceeding anyway might not work."
      fi

      # TODO: This seems to be a simple solution but it doesn't seem to be robust.. might be a betterway
      ${pkgs.curl}/bin/curl "$VAULT_ADDR" && echo "Attempting to unseal Vault..." || echo "waiting a second for Vault to start..." && sleep 5

      if ${package}/bin/vault operator unseal "$unseal_key"; then
          echo "Vault successfully unsealed."
      else
          echo "Error: Failed to unseal Vault, but the attempt was made."
      fi
    '';
  };

  write-policies-commands =
    mapAttrsToList
    (name: policy: ''
      echo Writing policy '${name}': '${policy}'
      vault policy write '${name}' '${policy}'
    '')
    policies;
  write-policies = concatStringsSep "\n" write-policies-commands;

  known-policies = mapAttrsToList (name: _value: name) policies;

  remove-unknown-policies = ''
    current_policies=$(vault policy list -format=json | jq -r '.[]')
    known_policies=(${
      concatStringsSep " "
      (builtins.map (policy: ''"${policy}"'') known-policies)
    })

    while read current_policy; do
      is_known=false

      for known_policy in "''${known_policies[@]}"; do
        if [ "$known_policy" = "$current_policy" ]; then
          is_known=true
          break
        fi
      done

      if [ "$is_known" = "false" ] && [ "$current_policy" != "default" ] && [ "$current_policy" != "root" ]; then
        echo "Removing policy: $current_policy"
        vault policy delete "$current_policy"
      else
        echo "Keeping policy: $current_policy"
      fi
    done <<< "$current_policies"
  '';
in {
  options.campground.services.vault = {
    enable = mkEnableOption "Vault";
    ui = mkBoolOpt true "Whether the UI should be enabled.";
    auto-unseal =
      mkBoolOpt false "Whether or not to auto unseal with Clevis & Tang";
    tang-unseal-key =
      mkOpt types.str "/var/lib/vault/unsealkey.enc"
      "Location of a Tang encrypted unseal key";
    storage = {
      backend = mkOpt types.str "file" "The storage backend for Vault.";
      path = mkOpt types.str "/var/lib/vault/data" "Path";
      config = mkOpt (types.nullOr types.str) null "Config";
    };
    address =
      mkOpt types.str "0.0.0.0:${toString cfg.port}"
      "Where to access vault UI at";
    port = mkOpt types.int 8200 "Port for UI";
    settings = mkOpt types.str "" "Configuration for Vault's config file.";
    mutable-policies =
      mkBoolOpt false
      "Whether policies not specified in Nix should be removed.";
    policies =
      mkOpt (types.attrsOf (types.either types.str types.path)) {}
      "Policies to install when Vault runs.";
    policy-agent = {
      user = mkOpt types.str "root" "The user to run the Vault Agent as.";
      group = mkOpt types.str "root" "The group to run the Vault Agent as.";
      auth = {
        roleIdFilePath =
          mkOpt types.str "/var/lib/vault/vault/role-id"
          "The file to read the role-id from.";
        secretIdFilePath =
          mkOpt types.str "/var/lib/vault/vault/secret-id"
          "The file to read the secret-id from.";
      };
    };
    snapshot = {
      enable = mkBoolOpt false "Should we make regular snapshots";
      vault-domain =
        mkOpt types.str "https://vault.lan.aicampground.com"
        "The domain name of the Vault";
      location =
        mkOpt types.str "/persist/vault" "The place to store the snapshot";
      schedule =
        mkOpt types.str "*-*-* 23:50:00 America/Chicago"
        "The schedule the snapshots should be run on";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [campground.vault-scripts];
    services.vault = mkIf cfg.enable {
      enable = true;
      address = cfg.address;
      inherit package;
      storageBackend = cfg.storage.backend;
      storagePath = cfg.storage.path;
      storageConfig = cfg.storage.config;
      extraConfig = ''
        ui = ${
          if cfg.ui
          then "true"
          else "false"
        }

        ${cfg.settings}
      '';
    };

    systemd.services.vault.postStart =
      mkIf cfg.enable "${unseal-script}/bin/celvis-unseal-vault";

    systemd.services.vault-policies = mkIf (cfg.enable && (has-policies || !cfg.mutable-policies)) {
      wantedBy = ["vault.service"];
      after = ["vault.service"];

      serviceConfig = {
        Type = "oneshot";
        User = cfg.policy-agent.user;
        Group = cfg.policy-agent.group;
        Restart = "on-failure";
        RestartSec = 30;
        RemainAfterExit = "yes";
      };

      restartTriggers =
        mapAttrsToList (name: value: "${name}=${value}") policies;

      path = [package pkgs.curl pkgs.jq];

      environment = {
        VAULT_ADDR = "http://${config.services.vault.address}";
      };

      script = ''
        if ! [ -f '${cfg.policy-agent.auth.roleIdFilePath}' ]; then
          echo 'role-id file not found: ${cfg.policy-agent.auth.roleIdFilePath}'
          exit 0
        fi

        if ! [ -f '${cfg.policy-agent.auth.secretIdFilePath}' ]; then
          echo 'secret-id file not found: ${cfg.policy-agent.auth.secretIdFilePath}'
          exit 0
        fi

        role_id="$(cat '${cfg.policy-agent.auth.roleIdFilePath}')"
        secret_id="$(cat '${cfg.policy-agent.auth.secretIdFilePath}')"

        seal_status=$(${pkgs.curl}/bin/curl -s "$VAULT_ADDR/v1/sys/seal-status" | jq ".sealed")

        echo "Seal Status: $seal_status"

        if [ seal_status = "true" ]; then
          echo "Vault is currently sealed, cannot install policies."
          exit 1
        fi

        echo "Getting token..."

        token=$(vault write -field=token auth/approle/login \
          role_id="$role_id" \
          secret_id="$secret_id" \
        )

        echo "Logging in..."

        export VAULT_TOKEN="$(vault login -method=token -token-only token="$token")"

        echo "Writing policies..."

        ${write-policies}

        ${optionalString (!cfg.mutable-policies) remove-unknown-policies}
        exit 0
      '';
    };

    systemd.services.vault-snapshot = mkIf (cfg.snapshot.enable && cfg.storage.backend == "raft") {
      description = "Vault Raft Snapshot Service";
      serviceConfig = {Type = "oneshot";};

      environment = {HOME = "/var/lib/vault";};

      script = ''
        # Paths to the AppRole credentials
        export VAULT_ADDR="${cfg.snapshot.vault-domain}"
        ROLE_ID_FILE="${config.campground.services.vault-agent.settings.vault.role-id}"
        SECRET_ID_FILE="${config.campground.services.vault-agent.settings.vault.secret-id}"

        # Check if the credential files exist
        if [[ ! -f "$ROLE_ID_FILE" || ! -f "$SECRET_ID_FILE" ]]; then
            echo "Error: AppRole credential files not found."
            exit 1
        fi

        # Read the credentials
        ROLE_ID=$(cat "$ROLE_ID_FILE")
        SECRET_ID=$(cat "$SECRET_ID_FILE")

        # Login to Vault using AppRole
        export VAULT_TOKEN=$(${package}/bin/vault write -field=token auth/approle/login role_id="$ROLE_ID" secret_id="$SECRET_ID")
        echo "Successfully logged in to Vault."

        mkdir -p ${cfg.snapshot.location}
        echo "Creating Vault Raft Snapshot."
        # take snapshot
        ${package}/bin/vault operator raft snapshot save ${cfg.snapshot.location}/vault-snapshot.backup
        # make sure snapshot is good
        ${package}/bin/vault operator raft snapshot inspect ${cfg.snapshot.location}/vault-snapshot.backup

        chown -R root:root ${cfg.snapshot.location}
        chmod 400 ${cfg.snapshot.location}/vault-snapshot.backup

        echo "Vault Snapshot verified..."

      '';
    };

    systemd.timers."vault-snapshot" = mkIf cfg.snapshot.enable {
      description = "Take regular snapshots of the Vault Raft DB";
      partOf = ["vault-snapshot.service"];
      timerConfig = {
        OnCalendar = cfg.snapshot.schedule;
        Persistent = true;
      };
      wantedBy = ["timers.target"];
    };
  };
}
