/*
arr - a stack of containers for managing downloads, requests and serving media
radarr, sonarr, bazarr, overseerr, jellyfin, readarr, transmission#TODO, plex#TODO and pyload-ng

no ports exposed on host system, nginx-wan / nginx-lan containers reverse proxy to containers
on an internal podman network
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.arr;
in {
  options.cont.arr = {
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
      # setup some systemd services
      systemd = {
        # root service - all containers, volumes and network started and ended by this target
        targets."podman-arr-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # network
          "podman-network-arr" = {
            script = ''podman network inspect arr || podman network create arr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f arr";
            };
          };
          # radarr container
          "podman-radarr" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-radarr.service"
              "podman-volume-arr-downloads.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-radarr.service"
              "podman-volume-arr-downloads.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # radar volume
          "podman-volume-arr-radarr" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-radarr || podman volume create arr-radarr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # sonarr container
          "podman-sonarr" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-sonarr.service"
              "podman-volume-arr-downloads.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-sonarr.service"
              "podman-volume-arr-downloads.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # sonarr volume
          "podman-volume-arr-sonarr" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-sonarr || podman volume create arr-sonarr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # bazarr container
          "podman-arr-bazarr" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-arr-bazarr.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-bazarr.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # bazarr volume
          "podman-volume-arr-bazarr" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-bazarr || podman volume create arr-bazarr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # pyload-ng container
          "podman-arr-pyload" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-arr-pyload.service"
              "podman-volume-arr-downloads.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-pyload.service"
              "podman-volume-arr-downloads.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # pyload-ng volume
          "podman-volume-arr-pyload" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-pyload || podman volume create arr-pyload'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # overseerr container
          "podman-arr-overseerr" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-arr-overseerr.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-overseerr.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # overseerr volume
          "podman-volume-overseerr" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-overseerr || podman volume create arr-overseerr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # readarr container
          "podman-arr-readarr" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-arr-readarr.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-readarr.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # readarr volume
          "podman-volume-readarr" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-readarr || podman volume create arr-readarr'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # jellyfin container
          "podman-arr-jellyfin" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-jellyfin.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-jellyfin.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # jellyfin volume
          "podman-volume-arr-jellyfin" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-jellyfin || podman volume create arr-jellyfin'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # transmission container
          "podman-arr-transmission" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-transmission.service"
              "podman-volume-arr-downloads.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-transmission.service"
              "podman-volume-arr-downloads.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # transmission volume
          "podman-volume-arr-transmission" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-transmission || podman volume create arr-transmission'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # download dir shared between all containers - #TODO change where this is stored
          "podman-volume-arr-downloads" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-downloads || podman volume create arr-downloads'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
        };
      };

      # podman containers
      virtualisation.oci-containers.containers = {
        #
        "arr-radarr" = {
          image = "lscr.io/linuxserver/radarr:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-radarr:/config:rw"
            # "/path/to/movies:/movies"
            "arr-downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=radarr"
            "--network=arr"
          ];
        };
        #
        "arr-sonarr" = {
          image = "lscr.io/linuxserver/sonarr:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-sonarr:/config:rw"
            # "/path/to/tv_shows:/tv"
            "arr-downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=sonarr"
            "--network=arr"
          ];
        };
        #
        "arr-bazarr" = {
          image = "lscr.io/linuxserver/bazarr:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-bazarr:/config:rw"
            # "/path/to/tv_shows:/tv"
            # "/path/to/movies:/movies"
          ];
          extraOptions = [
            "--network-alias=bazarr"
            "--network=arr"
          ];
        };
        "arr-pyload" = {
          image = "lscr.io/linuxserver/pyload-ng:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-pyload:/config:rw"
            "arr-downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=pyload"
            "--network=arr"
          ];
        };
        #
        "arr-overseerr" = {
          image = "lscr.io/linuxserver/overseerr:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-overseerr:/app/config"
          ];
          extraOptions = [
            "--network-alias=overseerr"
            "--network=arr"
          ];
        };
        #
        "arr-readarr" = {
          image = "lscr.io/linuxserver/readarr:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-readarr:/config"
            # "/path/to/books:/books" #TODO
            "arr-downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=readarr"
            "--network=arr"
          ];
        };
        #
        "arr-transmission" = {
          image = "lscr.io/linuxserver/transmission:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
            DOCKER_MODS = "linuxserver/mods:transmission-floodui";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-transmission:/config"
            "arr-downloads:/downloads"
          ];
          extraOptions = [
            "--network-alias=transmission"
            "--network=arr"
          ];
        };
        #
        "arr-jellyfin" = {
          image = "lscr.io/linuxserver/jellyfin:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-jellyfin:/config"
            # "/path/to/tv_shows:/data/tvshows"
            # "/path/to/movies:/data/movies"
          ];
          extraOptions = [
            "--network-alias=jellyfin"
            "--network=arr"
          ];
        };
      };
    })
  ];
}
