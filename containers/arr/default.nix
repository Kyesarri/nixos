/*
arr - a stack of containers for managing downloads
radarr, sonarr, bazarr, readarr and pyload-ng
*/
{
  secrets, # temp - mkoption for ip on macvlan
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
    contName = mkOption {
      type = types.str;
      default = "arr-${config.networking.hostName}";
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
          # nginx container
          "podman-arr-nginx" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-arr.service"
              "podman-volume-arr-nginx.service"
            ];
            requires = [
              "podman-network-arr.service"
              "podman-volume-arr-nginx.service"
            ];
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # nginx volume
          "podman-volume-arr-nginx" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect arr-nginx || podman volume create arr-nginx'';
            partOf = ["podman-arr-root.target"];
            wantedBy = ["podman-arr-root.target"];
          };
          # download dir shared between all containers - #TODO change where this is stored via script
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
        "arr-nginx" = {
          image = "docker.io/jc21/nginx-proxy-manager:latest";
          log-driver = "journald";
          environment = {
            TZ = "${cfg.timeZone}";
            PUID = "1000";
            PGID = "1000";
          };
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "arr-nginx/data:/data:rw"
            "arr-nginx/letsencrypt:/etc/letsencrypt:rw"
          ];
          extraOptions = [
            "--network-alias=nginx"
            "--network=macvlan_lan:ip=${secrets.ip.nginx-arr},interface_name=eth0" # temp - mkoption for ip on macvlan
            "--network=arr:interface_name=eth1"
          ];
        };
      };
    })
  ];
}
