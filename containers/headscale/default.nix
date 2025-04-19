{
  config,
  # pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.headscale;
in {
  options.cont.headscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      virtualisation.oci-containers.containers = {
        "headscale" = {
          image = "headscale/headscale:latest";
          log-driver = "journald";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "headscale:/etc/headscale"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
          };
          cmd = ["serve"];
          extraOptions = [
            "--network-alias=headscale"
            "--privileged"
            "--network=internal"
          ];
        };
        "headscale-ui" = {
          image = "ghcr.io/gurucomputing/headscale-ui:latest";
          log-driver = "journald";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
          };
          cmd = ["serve"];
          extraOptions = [
            "--network-alias=headscale-ui"
            "--privileged"
            "--network=internal"
          ];
        };
        "derp" = {
          image = "ghcr.io/tijjjy/tailscale-derp-docker:latest";
          log-driver = "journald";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/run/current-system/kernel-modules:/lib/modules:ro" # icky - do we want a VM for this?
            "derp:/root/derper/derp"
            "headscale:/var/lib/tailscale"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
            TAILSCALE_DERP_HOSTNAME = "${cfg.hostName}";
            TAILSCALE_DERP_VERIFY_CLIENTS = "${cfg.verifyClients}";
            TAILSCALE_DERP_CERTMODE = "${cfg.certMode}";
            TAILSCALE_AUTH_KEY = "${cfg.authKey}";
          };
          cmd = [];
          extraOptions = [
            "--network-alias=derp"
            "--privileged"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
