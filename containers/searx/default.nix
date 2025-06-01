{
  pkgs,
  lib,
  ...
}: {
  # root target / service
  systemd.targets."podman-searxng-root" = {
    unitConfig = {Description = "root target.";};
    wantedBy = ["multi-user.target"];
  };

  systemd.services."podman-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = [
      "podman-network-searxng.service"
      "podman-volume-searxng_valkey-data.service"
    ];
    requires = [
      "podman-network-searxng.service"
      "podman-volume-searxng_valkey-data.service"
    ];
    partOf = ["podman-searxng-root.target"];
    wantedBy = ["podman-searxng-root.target"];
  };

  systemd.services."podman-searxng-cloudflared" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = ["podman-network-searxng.service"];
    requires = ["podman-network-searxng.service"];
    partOf = ["podman-searxng-root.target"];
    wantedBy = ["podman-searxng-root.target"];
  };

  systemd.services."podman-searxng" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
    };
    after = ["podman-network-searxng.service"];
    requires = ["podman-network-searxng.service"];
    partOf = ["podman-searxng-root.target"];
    wantedBy = ["podman-searxng-root.target"];
  };

  systemd.services."podman-network-searxng" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f searxng";
    };
    script = ''
      podman network inspect searxng || podman network create searxng
    '';
    partOf = ["podman-searxng-root.target"];
    wantedBy = ["podman-searxng-root.target"];
  };

  systemd.services."podman-volume-searxng_valkey-data" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect searxng_valkey-data || podman volume create searxng_valkey-data
    '';
    partOf = ["podman-searxng-root.target"];
    wantedBy = ["podman-searxng-root.target"];
  };

  # containers
  virtualisation.oci-containers.containers = {
    "redis" = {
      image = "docker.io/valkey/valkey:8-alpine";
      volumes = [
        "searxng_valkey-data:/data:rw"
      ];
      cmd = ["valkey-server" "--save" "30" "1" "--loglevel" "warning"];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=redis"
        "--network=searxng_searxng"
      ];
    };

    "searxng" = {
      image = "docker.io/searxng/searxng:latest";
      environment = {
        "SEARXNG_BASE_URL" = "https://searx.galing.org/";
        "UWSGI_THREADS" = "4";
        "UWSGI_WORKERS" = "4";
      };
      volumes = [
        # need to re-create this as a local dir
        # want to configure the .env and other files
        # the nix way
        "/etc/oci.cont/searxng:/etc/searxng:rw"
      ];
      ports = [
        # no ports required to be opened on host, we're using cloudflared
        # "127.0.0.1:8080:8080/tcp"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=searxng"
        "--network=searxng"
      ];
    };

    "searxng-cloudflared" = {
      log-driver = "journald";
      image = "cloudflare/cloudflared:latest";
      environment = {
        "TZ" = "Australia/Melbourne";
        "TUNNEL_TOKEN" = "${secrets.cloudflare.searxng}";
      };
      cmd = ["tunnel" "--no-autoupdate" "run"];
      extraOptions = [
        # remember to add networks you want to expose via tunnel,
        # i didnt and wasted two days trying to get this to work :D
        "--network-alias=searx-cloudflared"
        "--network=searxng"
      ];
    };
  };
}
