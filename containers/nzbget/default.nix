/*
NZBGet is an advanced NZB downloader designed to efficiently retrieve articles from Usenet newsgroups.
It is built for high performance and low resource consumption, making it ideal for users looking for a fast, automated Usenet experience.
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.nzbget;
in {
  options.cont.nzbget = {
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
      # add shell alias to update container
      environment.shellAliases = {cont-nzbget = "sudo podman pull lscr.io/linuxserver/nzbget:latest";};

      systemd = {
        # root service
        targets."podman-nzbget-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-nzbget" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              "podman-volume-nzbget.service"
            ];
            requires = [
              "podman-network-internal.service"
              "podman-volume-nzbget.service"
            ];
            partOf = ["podman-nzbget-root.target"];
            wantedBy = ["podman-nzbget-root.target"];
          };
          # volume
          "podman-volume-nzbget" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect nzbget || podman volume create nzbget'';
            partOf = ["podman-nzbget-root.target"];
            wantedBy = ["podman-nzbget-root.target"];
          };
        };
      };
      # container
      # port 6789
      virtualisation.oci-containers.containers."nzbget" = {
        image = "lscr.io/linuxserver/nzbget:latest";
        log-driver = "journald";
        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
          NZBGET_USER = "nzbget"; #optional
          NZBGET_PASS = "tegbzn6789"; #optional
        };
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "nzbget:/config:rw"
          "/hddf/nzb:/downloads:rw"
        ];
        extraOptions = [
          "--network-alias=nzbget"
          "--network=internal"
        ];
      };
    })
  ];
}
