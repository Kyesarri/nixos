/*
Pinchflat is a self-hosted app for downloading YouTube content built using yt-dlp.
It's designed to be lightweight, self-contained, and easy to use.
You set up rules for how to download content from YouTube channels or playlists and it'll do the rest, periodically checking for new content.
It's perfect for people who want to download content for use in with a media center app (Plex, Jellyfin, Kodi) or for those who want to archive media!
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.pinchflat;
in {
  options.cont.pinchflat = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd = {
        targets."podman-pinchflat-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # container
          "podman-pinchflat" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-pinchflat.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-pinchflat.service"
            ];
            partOf = ["podman-pinchflat-root.target"];
            wantedBy = ["podman-pinchflat-root.target"];
          };

          # volumes
          "podman-volume-pinchflat" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect pinchflat || podman volume create pinchflat'';
            partOf = ["podman-pinchflat-root.target"];
            wantedBy = ["podman-pinchflat-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "pinchflat" = {
          image = "ghcr.io/kieraneglin/pinchflat:latest";
          log-driver = "journald";
          environment = {
            TZ = "Australia/Melbourne";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "i2pd:/config"
            "/mnt/storage/youtube:/downloads"
          ];
          extraOptions = [
            "--network-alias=pinchflat"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
