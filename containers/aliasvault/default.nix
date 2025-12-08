/*
AliasVault

A privacy-first password manager with built-in email aliasing.
Fully encrypted and self-hostable.

Self hosted / single container install
*/
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}: {
  systemd = {
    targets."podman-aliasvault-root" = {
      unitConfig = {Description = "root target";};
      wantedBy = ["multi-user.target"];
    };

    services = {
      "podman-aliasvault" = {
        serviceConfig = {Restart = lib.mkOverride 90 "always";};
        after = [
          "podman-network-aliasvault.service"
          "podman-aliasvault-cloudflared.service"
        ];
        requires = [
          "podman-aliasvault.service"
          "podman-aliasvault-cloudflared.service"
        ];
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
      };

      "podman-aliasvault-cloudflared" = {
        serviceConfig = {Restart = lib.mkOverride 90 "always";};
        after = ["podman-network-aliasvault.service"];
        requires = ["podman-network-aliasvault.service"];
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
      };

      "podman-volume-aliasvault-db" = {
        path = [pkgs.podman];
        script = ''podman volume inspect aliasvault-db || podman volume create aliasvault-db'';
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      "podman-volume-aliasvault-logs" = {
        path = [pkgs.podman];
        script = ''podman volume inspect aliasvault-logs || podman volume create aliasvault-logs'';
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      "podman-volume-aliasvault-secrets" = {
        path = [pkgs.podman];
        script = ''podman volume inspect aliasvault-secrets || podman volume create aliasvault-secrets'';
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      "podman-network-aliasvault" = {
        path = [pkgs.podman];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStop = "podman network rm -f aliasvault";
        };
        script = ''podman network inspect aliasvault || podman network create aliasvault'';
        partOf = ["podman-aliasvault-root.target"];
        wantedBy = ["podman-aliasvault-root.target"];
      };
    };
  };

  virtualisation.oci-containers.containers = {
    "aliasvault" = {
      image = "ghcr.io/aliasvault/aliasvault:latest";
      environment = {
        "TZ" = "Australia/Melbourne";
        "FORCE_HTTPS_REDIRECT" = "false";
        "HOSTNAME" = "localhost";
        "IP_LOGGING_ENABLED" = "true";
        "PRIVATE_EMAIL_DOMAINS" = "";
        "PUBLIC_REGISTRATION_ENABLED" = "true";
        "SUPPORT_EMAIL" = "";
      };
      volumes = [
        "aliasvault-db:/database:rw"
        "aliasvault-logs:/logs:rw"
        "aliasvailt-secrets:/secrets:rw"
      ];
      ports = [
        # "80:80/tcp"
        # "443:443/tcp"
        # "25:25/tcp"
        # "587:587/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=aliasvault"
        "--network=aliasvault"
      ];
    };

    "aliasvault-cloudflared" = {
      log-driver = "journald";
      image = "cloudflare/cloudflared:latest";
      environment = {
        "TZ" = "Australia/Melbourne";
        "TUNNEL_TOKEN" = "${secrets.cloudflare.aliasvault}";
      };
      cmd = ["tunnel" "--no-autoupdate" "run"];
      extraOptions = [
        "--network-alias=aliasvault-cloudflared"
        "--network=aliasvault"
      ];
    };
  };
}
