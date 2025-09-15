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
  cfg = config.cont.i2pd;
in {
  options.cont.i2pd = {
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
        targets."podman-i2pd-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-i2pd" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volumes-i2pd.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volumes-i2pd.service"
            ];
            partOf = ["podman-i2pd-root.target"];
            wantedBy = ["podman-i2pd-root.target"];
          };
          # volumes
          "podman-volumes-i2pd" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect i2pd-2 || podman volume create i2pd-2 && \
              podman volume inspect i2pd || podman volume create i2pd
            '';
            partOf = ["podman-i2pd-root.target"];
            wantedBy = ["podman-i2pd-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        "i2pd" = {
          image = "purplei2p/i2pd:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            http.strictheaders = "false";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "i2pd-2:/home/.i2pd/"
            "i2pd:/home/i2pd/"
          ];
          # cmd = ["--http.address i2pd" "--port=54369"];
          extraOptions = [
            "--network-alias=i2pd"
            "--network=internal"
          ];
        };
      };
    })
  ];
}
