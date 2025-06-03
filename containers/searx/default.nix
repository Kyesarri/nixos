{
  secrets,
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

  system.activationScripts.makeSearxNGDir = lib.stringAfter ["var"] ''mkdir -v -p /etc/oci.cont/searxng'';

  environment.shellAliases = {cont-searxng = "sudo podman pull docker.io/searxng/searxng:latest";};
  # write files from tree to specific directory
  environment.etc = {
    "oci.cont/searxng/searx/static/themes/simple/image/favicon.svg" = {
      mode = "644";
      source = ./favicon.svg;
    };

    "oci.contsearxng/searx/static/themes/simple/image/searxng.svg" = {
      mode = "644";
      source = ./searxng.svg;
    };
  };
  # write configs to location
  environment.etc = {
    "oci.cont/searxng/settings.yml" = {
      mode = "644";
      text = ''
        use_default_settings: true

        general:
          debug: false
          instance_name: "searx"
          privacypolicy_url: false
          donation_url: false
          contact_url: false
          enable_metrics: true

        server:
          secret_key: "${secrets.searxng.key}"
          limiter: false #TODO
          image_proxy: true

        ui:
          static_path: ""
          static_use_hash: true
          query_in_title: false
          infinite_scroll: true
          default_theme: simple
          center_alignment: true
          default_locale: ""
          theme_args:
            simple_style: dark

        redis:
          url: redis://redis:6379/0
      '';
    };

    "oci.cont/searxng/limiter.toml" = {
      mode = "644";
      text = ''
        # This configuration file updates the default configuration file
        # See https://github.com/searxng/searxng/blob/master/searx/limiter.toml

        [botdetection.ip_limit]
        # activate advanced bot protection
        # enable this when running the instance for a public usage on the internet
        link_token = false
      '';
    };
  };

  # containers
  virtualisation.oci-containers.containers = {
    "searxng-redis" = {
      image = "docker.io/valkey/valkey:8-alpine";
      volumes = [
        "searxng_valkey-data:/data:rw"
      ];
      cmd = ["valkey-server" "--save" "30" "1" "--loglevel" "warning"];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=redis"
        "--network=searxng"
      ];
    };

    "searxng" = {
      image = "docker.io/searxng/searxng:latest";
      environment = {
        SEARXNG_BASE_URL = "https://searx.galing.org/";
        UWSGI_THREADS = "4";
        UWSGI_WORKERS = "4";
      };
      volumes = [
        "/etc/oci.cont/searxng:/etc/searxng:rw"
        # write files from our host tree to container
      ];
      ports = [
        # no ports required to be opened on host, we're using cloudflared
        # to tunnel the connection
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
        "--network-alias=searx-cloudflared"
        "--network=searxng"
      ];
    };
  };
}
