/*
Syncthing replaces proprietary sync and cloud services with something open, trustworthy and decentralized.
Your storage is your storage alone and you deserve to choose where it is stored,
if it is shared with some third party and how it's transmitted over the Internet.
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.syncthing;
in {
  options.cont.syncthing = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
    };
    macvlanIp = types.str;
    default = "";
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root target
      systemd = {
        targets."podman-syncthing-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # container
          "podman-syncthing" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-syncthing-storage.service"
              "podman-volume-syncthing-config.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-syncthing-storage.service"
              "podman-volume-syncthing-config.service"
            ];
            partOf = ["podman-syncthing-root.target"];
            wantedBy = ["podman-syncthing-root.target"];
          };
          # storage volume
          "podman-volume-syncthing-storage" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect syncthing-storage || podman volume create syncthing-storage'';
            partOf = ["podman-syncthing-root.target"];
            wantedBy = ["podman-syncthing-root.target"];
          };
          # config volume
          "podman-volume-syncthing-config" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect syncthing-config || podman volume create syncthing-config'';
            partOf = ["podman-syncthing-root.target"];
            wantedBy = ["podman-syncthing-root.target"];
          };
        };
      };

      # container
      virtualisation.oci-containers.containers = {
        "syncthing" = {
          image = "lscr.io/linuxserver/syncthing:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "syncthing-storage:/storage"
            "syncthing-config:/config"
          ];
          extraOptions = [
            "--network-alias=syncthing"
            "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          ];
        };
      };
    })
  ];
}
