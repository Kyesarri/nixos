/*
Radicale is a small but powerful CalDAV (calendars, to-do lists) and CardDAV (contacts) server
*/
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.radicale;
in {
  options.cont.radicale = {
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
      # this container will use storage on host, so we can write some files to preconfigure.
      # probs is a better way to do this by env vars?
      system.activationScripts."makeradicaleDir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/radicale/data /etc/oci.cont/radicale/config & chown -R 1000:1000 /etc/oci.cont/radicale'';

      environment.shellAliases = {cont-radicale = "sudo podman pull grepular/radicale";};

      environment.etc = {
        # write some basic configs for our container
        "oci.cont/radicale/config/config" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''
            [server]
            hosts = 0.0.0.0:5232

            [auth]
            type = htpasswd
            htpasswd_filename = /config/users
            htpasswd_encryption = bcrypt

            [storage]
            filesystem_folder = /data/collections
          '';
        };
        #
        "oci.cont/radicale/config/users" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''kel:${secrets.password.radicale}'';
        };
      };

      systemd = {
        # root service
        targets."podman-radicale-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };
        services = {
          # container
          "podman-radicale" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-internal.service"
              # "podman-volume-radicale.service"
            ];
            requires = [
              "podman-network-internal.service"
              # "podman-volume-radicale.service"
            ];
            partOf = ["podman-radicale-root.target"];
            wantedBy = ["podman-radicale-root.target"];
          };
          # volume
          /*
            "podman-volume-radicale" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect radicale-config || podman volume create radicale-config && \
              podman volume inspect radicale-data || podman volume create radicale-data
            '';
            partOf = ["podman-radicale-root.target"];
            wantedBy = ["podman-radicale-root.target"];
          };
          */
        };
      };

      virtualisation.oci-containers.containers."radicale" = {
        image = "grepular/radicale:latest";
        log-driver = "journald";
        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
        };
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/radicale/config:/etc/radicale:ro"
          "/etc/oci.cont/radicale/data:/var/lib/radicale"
        ];
        extraOptions = [
          "--network-alias=radicale"
          "--network=internal"
        ];
      };
    })
  ];
}
