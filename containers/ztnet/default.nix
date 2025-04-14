/*
ZTNET - ZeroTier Controller Web UI is a robust and versatile application designed to transform the management of ZeroTier networks.
Now featuring organization and multi-user support, it elevates the network management experience, accommodating team-based environments and larger organizations seamlessly.
# added some c2n configs here, additional systemd units and networking configs
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.ztnet;
in {
  options.cont.ztnet = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
    #
    contName = mkOption {
      type = types.str;
      default = "ztnet-${config.networking.hostName}";
      example = "container-cool-hostname";
      description = "container name and container volume dirs";
    };

    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      systemd = {
        # root service
        targets."podman-ztnet-root" = {
          unitConfig = {Description = "root target from c2n";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # network
          "podman-ztnetwork" = {
            script = ''podman network inspect ztnetwork || podman network create ztnetwork --driver=bridge --subnet=172.31.255.0/29'';
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f ztnetwork";
            };
          };

          # systemd services for containers
          # postgres
          "podman-postgres-${cfg.contName}" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-postgres.service"
            ];
            requires = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-postgres.service"
            ];
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
          };
          # ztnet
          "podman-${cfg.contName}" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-zerotier.service"
            ];
            requires = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-zerotier.service"
            ];
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
          };
          # zerotier
          "podman-zerotier-${cfg.contName}" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-zerotier.service"
            ];
            requires = [
              "podman-ztnetwork.service"
              "podman-volume-ztnet-zerotier.service"
            ];
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
          };

          # container volumes
          # postgres
          "podman-volume-ztnet-postgres" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect ztnet-postgres || podman volume create ztnet-postgres'';
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
          };
          # zerotier
          "podman-volume-ztnet-zerotier" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''podman volume inspect ztnet-zerotier || podman volume create ztnet-zerotier'';
            partOf = ["podman-ztnet-root.target"];
            wantedBy = ["podman-ztnet-root.target"];
          };
        };
      };

      virtualisation.oci-containers.containers = {
        # postgres
        "postgres-${cfg.contName}" = {
          image = "postgres:15.2-alpine";
          environment = {
            TZ = "${cfg.timeZone}";
            "POSTGRES_DB" = "ztnet";
            "POSTGRES_PASSWORD" = "postgres";
            "POSTGRES_USER" = "postgres";
          };
          volumes = [
            "ztnet-postgres:/var/lib/postgresql/data:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=postgres"
            "--network=ztnetwork"
          ];
        };
        # zerotier
        "zerotier-${cfg.contName}" = {
          autoStart = true;
          image = "zyclonite/zerotier:1.14.2";
          volumes = [
            "/etc/localtime:/etc/localtime:ro"
            "ztnet-zerotier:/var/lib/zerotier-one:rw"
          ];
          environment = {
            TZ = "${cfg.timeZone}";
            ZT_OVERRIDE_LOCAL_CONF = "true";
            ZT_ALLOW_MANAGEMENT_FROM = "172.31.255.0/29";
          };
          ports = ["9993:9993/udp"];
          log-driver = "journald";
          extraOptions = [
            "--cap-add=NET_ADMIN"
            "--cap-add=SYS_ADMIN"
            "--device=/dev/net/tun:/dev/net/tun:rwm"
            "--hostname=zerotier"
            "--network-alias=zerotier"
            "--network=ztnetwork"
          ];
        };
        # ztnet
        "ztnet-${cfg.contName}" = {
          image = "sinamics/ztnet:latest";
          environment = {
            TZ = "${cfg.timeZone}";
            "NEXTAUTH_SECRET" = "random_secret";
            "NEXTAUTH_URL" = "http://localhost:3000";
            "NEXTAUTH_URL_INTERNAL" = "http://ztnet:3000";
            "POSTGRES_DB" = "ztnet";
            "POSTGRES_HOST" = "postgres";
            "POSTGRES_PASSWORD" = "postgres";
            "POSTGRES_PORT" = "5432";
            "POSTGRES_USER" = "postgres";
          };
          volumes = [
            "ztnet-zerotier:/var/lib/zerotier-one:rw"
          ];
          ports = ["3000:3000/tcp"];
          dependsOn = [
            "postgres"
            "zerotier"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=ztnet"
            "--network=ztnetwork"
          ];
        };
      };
    })
  ];
}
