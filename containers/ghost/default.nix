/*
Ghost is an independent platform for publishing online by web and email newsletter.
It has user signups, gated access and subscription payments built-in (with Stripe)
 to allow you to build a direct relationship with your audience.
It's fast, user-friendly, and runs on Node.js & MySQL8.
*/
{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.ghost;
in {
  options.cont.ghost = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    cloudflared-token = mkOption {
      type = types.str;
      default = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # root-target
      systemd = {
        targets."podman-ghost-root" = {
          wantedBy = ["multi-user.target"];
          unitConfig = {Description = "root-target-ghost";};
        };

        services = {
          # containers

          "podman-ghost-db" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-ghost.service"
              "podman-volume-ghost_db.service"
            ];
            requires = [
              "podman-network-ghost.service"
              "podman-volume-ghost_db.service"
            ];
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
          };

          "podman-ghost-ghost" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-ghost.service"
              "podman-volume-ghost.service"
            ];
            requires = [
              "podman-network-ghost.service"
              "podman-volume-ghost.service"
            ];
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
          };

          "podman-ghost-cloudflared" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = ["podman-network-ghost.service"];
            requires = ["podman-network-ghost.service"];
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
          };

          # network
          "podman-network-ghost" = {
            path = [pkgs.podman];
            script = ''podman network inspect ghost || podman network create ghost'';
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f ghost";
            };
          };

          # volumes
          "podman-volume-ghost_db" = {
            path = [pkgs.podman];
            script = ''podman volume inspect ghost_db || podman volume create ghost_db'';
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };
          "podman-volume-ghost" = {
            path = [pkgs.podman];
            script = ''podman volume inspect ghost || podman volume create ghost'';
            partOf = ["podman-ghost-root.target"];
            wantedBy = ["podman-ghost-root.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };
        };
      };

      virtualisation.oci-containers.containers = {
        # containers
        "ghost-db" = {
          image = "mysql:8.0";
          environment = {
            "MYSQL_ROOT_PASSWORD" = "example";
            TZ = "Australia/Melbourne";
          };
          volumes = [
            "ghost_db:/var/lib/mysql:rw"
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=db"
            "--network=ghost"
          ];
        };

        "ghost" = {
          image = "ghost:5-alpine";
          environment = {
            "database__client" = "mysql";
            "database__connection__database" = "ghost";
            "database__connection__host" = "db";
            "database__connection__password" = "example";
            "database__connection__user" = "root";
            "url" = "http://db:8080"; # unsure if this will work correctly
            TZ = "Australia/Melbourne";
          };
          volumes = [
            "ghost:/var/lib/ghost/content:rw"
          ];
          ports = [
            # "8080:2368/tcp" # using cloudflared
          ];
          log-driver = "journald";
          extraOptions = [
            "--network-alias=ghost"
            "--network=ghost"
          ];
        };

        "ghost-cloudflared" = {
          log-driver = "journald";
          image = "cloudflare/cloudflared:latest";
          environment = {
            "TZ" = "Australia/Melbourne";
            "TUNNEL_TOKEN" = "${cfg.cloudflared-token}";
          };
          cmd = ["tunnel" "--no-autoupdate" "run"];
          extraOptions = [
            "--network-alias=ghost-cloudflared"
            "--network=ghost"
          ];
        };
      };
    })
  ];
}
