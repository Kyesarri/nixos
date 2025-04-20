{
  config,
  pkgs,
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
      systemd = {
        targets."podman-headscale-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # containers
          "podman-headscale" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-headscale.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-headscale.service"
            ];
            partOf = ["podman-headscale-root.target"];
            wantedBy = ["podman-headscale-root.target"];
          };
          "podman-headscale-ui" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-headscale.service"
            ];
            requires = [
              "podman-network-internal.service"
            ];
            partOf = ["podman-headscale-root.target"];
            wantedBy = ["podman-headscale-root.target"];
          };
          "podman-derp" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-derp.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-derp.service"
            ];
            partOf = ["podman-headscale-root.target"];
            wantedBy = ["podman-headscale-root.target"];
          };
          # volumes
          "podman-volume-headscale" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect headscale || podman volume create headscale'';
            partOf = ["podman-headscale-root.target"];
            wantedBy = ["podman-headscale-root.target"];
          };
          "podman-volume-derp" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect derp || podman volume create derp'';
            partOf = ["podman-headscale-root.target"];
            wantedBy = ["podman-headscale-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "headscale" = {
          image = "headscale/headscale:latest";
          log-driver = "journald";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "headscale:/etc/headscale:rw"
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
            TAILSCALE_DERP_HOSTNAME = "derp";
            # TAILSCALE_DERP_VERIFY_CLIENTS = "${cfg.verifyClients}";
            # TAILSCALE_DERP_CERTMODE = "${cfg.certMode}";
            # TAILSCALE_AUTH_KEY = "${cfg.authKey}";
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
