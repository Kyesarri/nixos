/*
Secure credentials for secrets, certificates, keys, and more
Vault provides organizations with identity-based security to automatically
authenticate and authorize access to secrets and other sensitive data.

https://github.com/nrdxp/bitte/blob/c60e426bdaac0c755f25aa30d0e5ed03df01f269/profiles/vault/server.nix#L18
*/
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.gnocchi.vault;
in {
  options.gnocchi.vault = {
    enable = mkEnableOption "vault";
  };
  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # firewall ports probaby not required anymore, assuming nix would handle those being opened by default
      # leaving in anyways
      networking.firewall.allowedTCPPorts = [8200 8201];

      services = {
        vault = {
          enable = true;
          package = pkgs.vault;
          address = "127.0.0.1:8200";
          # tlsKeyFile = ""; # TLS private key file. TLS will be disabled unless this option is set
          storagePath = ""; # Data directory for file backend | null or absolute path
          extraConfig = "";
          storageConfig = ""; # Confidential values should not be specified here because this option’s value is written to the Nix store
          storageBackend = ""; # The name of the type of storage backend
          extraSettingsPaths = []; # list of absolute path
        };
      };
    })
  ];
}
