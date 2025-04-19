/**/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.doubletake;
in {
  options.cont.doubletake = {
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
        targets."podman-doubletake-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-doubletake" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-doubletake.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-doubletake.service"
            ];
            partOf = ["podman-doubletake-root.target"];
            wantedBy = ["podman-doubletake-root.target"];
          };
          # volume
          "podman-volume-doubletake" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect doubletake || podman volume create doubletake'';
            partOf = ["podman-doubletake-root.target"];
            wantedBy = ["podman-doubletake-root.target"];
          };
        };
      };
      # container
      virtualisation.oci-containers.containers = {
        "doubletake" = {
          image = "skrashevich/double-take:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "doubletake:/.storage:rw"
          ];
          extraOptions = [
            "--network-alias=doubletake"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
