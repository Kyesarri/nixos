{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.dms;
in {
  # https://github.com/docker-mailserver/docker-mailserver/blob/master/compose.yaml
  options.cont.dms = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    fqdn = mkOption {
      type = types.str;
      default = "mail.example.com";
    };
    image = mkOption {
      type = types.str;
      default = "ghcr.io/docker-mailserver/docker-mailserver:latest";
    };
  };

  /*
  sudo podman exec -t -i <CONTAINER_ID> setup email add user@example.org
  */

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      # pull latest image
      environment.shellAliases = {cont-dms = "sudo podman pull ${cfg.image}";};

      # systemd
      systemd = {
        # root target
        targets."podman-dms-root" = {
          unitConfig = {Description = "root target";};
          wantedBy = ["multi-user.target"];
        };

        services = {
          # network
          "podman-network-dms" = {
            script = ''podman network inspect dms || podman network create dms'';
            partOf = ["podman-dms-root.target"];
            wantedBy = ["podman-dms-root.target"];
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStop = "podman network rm -f dms";
            };
          };

          # dms
          "podman-dms" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-dms.service"
              "podman-volumes-dms.service"
            ];
            requires = [
              "podman-network-dms.service"
              "podman-volumes-dms.service"
            ];
            partOf = ["podman-dms-root.target"];
            wantedBy = ["podman-dms-root.target"];
          };

          # cloudflared
          "podman-dms-cloudflared" = {
            serviceConfig = {Restart = lib.mkOverride 90 "always";};
            after = [
              "podman-network-dms.service"
              "podman-dms.service"
            ];
            requires = [
              "podman-network-dms.service"
              "podman-dms.service"
            ];
            partOf = ["podman-dms-root.target"];
            wantedBy = ["podman-dms-root.target"];
          };

          # dms volumes
          "podman-volumes-dms" = {
            path = [pkgs.podman];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
            script = ''
              podman volume inspect dms-mail || podman volume create dms-mail && \
              podman volume inspect dms-state || podman volume create dms-state && \
              podman volume inspect dms-logs || podman volume create dms-logs && \
              podman volume inspect dms-config || podman volume create dms-config
            '';
            partOf = ["podman-dms-root.target"];
            wantedBy = ["podman-dms-root.target"];
          };
        };
      };

      # cloudflared container
      virtualisation.oci-containers.containers."dms-cloudflared" = {
        log-driver = "journald";
        image = "cloudflare/cloudflared:latest";
        environment = {
          "TZ" = "Australia/Melbourne";
          "TUNNEL_TOKEN" = "${secrets.cloudflare.mail}";
        };
        cmd = ["tunnel" "--no-autoupdate" "run"];
        extraOptions = [
          "--network-alias=dms-cloudflared"
          "--network=dms"
        ];
      };

      # dms container
      virtualisation.oci-containers.containers."dms" = {
        hostname = "${cfg.fqdn}";
        image = "${cfg.image}";
        log-driver = "journald";
        environment = {
          TZ = "Australia/Melbourne";
        };
        ports = [
          /*
          - "25:25"    # SMTP  (explicit TLS => STARTTLS)
          - "143:143"  # IMAP4 (explicit TLS => STARTTLS)
          - "465:465"  # ESMTP (implicit TLS)
          - "587:587"  # ESMTP (explicit TLS => STARTTLS)
          - "993:993"  # IMAP4 (implicit TLS)
          */
        ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "dms-mail:/var/mail/"
          "dms-state:/var/mail-state/"
          "dms-logs:/var/log/mail/"
          "dms-config:/tmp/docker-mailserver/"
        ];
        extraOptions = [
          "--network-alias=dms"
          "--network=dms"
        ];
      };
    })
  ];
}
