/*
Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.jellyfin;
in {
  options.cont.jellyfin = {
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
        targets."podman-jellyfin-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-jellyfin" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volumes-jellyfin.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volumes-jellyfin.service"
            ];
            partOf = ["podman-jellyfin-root.target"];
            wantedBy = ["podman-jellyfin-root.target"];
          };
          # data volume
          "podman-volumes-jellyfin" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect jellyfin-data || podman volume create jellyfin-data && \
              podman volume inspect jellyfin-config || podman volume create jellyfin-config
            '';
            partOf = ["podman-jellyfin-root.target"];
            wantedBy = ["podman-jellyfin-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "jellyfin" = {
          image = "linuxserver/jellyfin:latest";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "/dev/dri:/dev/dri" # hardware accel;
            "jellyfin-config:/config"
            "jellyfin-data:/core/data"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          extraOptions = [
            "--privileged"
            "--network-alias=jellyfin"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
