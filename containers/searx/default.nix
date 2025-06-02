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

  # write configs to location
  environment.etc = {
    "oci.cont/searxng/settings.yml" = {
      mode = "644";
      text = ''
        use_default_settings: false

        general:
          debug: false
          # displayed name
          instance_name: "searx.galing.org"
          # For example: https://example.com/privacy
          privacypolicy_url: false
          # use true to use your own donation page written in searx/info/en/donate.md
          # use false to disable the donation link
          donation_url: false
          # mailto:contact@example.com
          contact_url: false
          # record stats
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
          theme_args:
            simple_style: dark

        redis:
          url: redis://redis:6379/0

        engines:
          - name: arch linux wiki
            engine: archlinux
            shortcut: al

          - name: duckduckgo
            engine: duckduckgo
            shortcut: ddg

          - name: fdroid
            engine: fdroid
            shortcut: fd
            disabled: true

          - name: github
            engine: github
            shortcut: gh

          - name: codeberg
            # https://docs.searxng.org/dev/engines/online/gitea.html
            engine: gitea
            base_url: https://codeberg.org
            shortcut: cb
            disabled: false
          - name: google
            engine: google
            shortcut: go
            # additional_tests:
            #   android: *test_android
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
        "--network-alias=searx-cloudflared"
        "--network=searxng"
      ];
    };
  };
}
