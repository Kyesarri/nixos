{
  pkgs,
  lib,
  config,
  ...
}: {
  system.activationScripts."make-pangolin-dir" = lib.stringAfter ["var"] ''
    mkdir -v -p /etc/oci.cont/pangolin/config /etc/oci.cont/pangolin/config/letsencrypt /etc/oci.cont/config/pangolin/traefik \
      && chown -R 1000:1000 /etc/oci.cont/pangolin
  '';

  systemd.targets."podman-pangolin-root" = {
    unitConfig = {Description = "root target";};
    wantedBy = ["multi-user.target"];
  };

  systemd.services = {
    "podman-gerbil" = {
      serviceConfig = {Restart = lib.mkOverride 90 "always";};
      after = ["podman-network-pangolin.service"];
      requires = ["podman-network-pangolin.service"];
      partOf = ["podman-pangolin-root.target"];
      wantedBy = ["podman-pangolin-root.target"];
    };

    "podman-pangolin" = {
      serviceConfig = {Restart = lib.mkOverride 90 "always";};
      after = [
        "podman-network-pangolin.service"
        "podman-volume-pangolin-data.service"
        "podman-volume-pangolin-data.service"
      ];
      requires = [
        "podman-network-pangolin.service"
        "podman-volume-pangolin-data.service"
        "podman-volume-pangolin-data.service"
      ];
      partOf = ["podman-pangolin-root.target"];
      wantedBy = ["podman-pangolin-root.target"];
    };

    "podman-traefik" = {
      serviceConfig = {Restart = lib.mkOverride 90 "always";};
      after = [
        "podman-volume-pangolin-data.service"
        "podman-volume-pangolin-data.service"
      ];
      requires = [
        "podman-volume-pangolin-data.service"
        "podman-volume-pangolin-data.service"
      ];
      partOf = ["podman-pangolin-root.target"];
      wantedBy = ["podman-pangolin-root.target"];
    };

    # network
    "podman-network-pangolin" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStop = "podman network rm -f pangolin";
      };
      script = ''podman network inspect pangolin || podman network create pangolin --driver=bridge'';
      partOf = ["podman-pangolin-root.target"];
      wantedBy = ["podman-pangolin-root.target"];
    };

    # volumes
    "podman-volume-pangolin-data" = {
      path = [pkgs.podman];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      };
      script = ''podman volume inspect pangolin-data || podman volume create pangolin-data'';
      partOf = ["podman-pangolin-root.target"];
      wantedBy = ["podman-pangolin-root.target"];
    };
  };

  # containers
  virtualisation.oci-containers.containers = {
    "gerbil" = {
      image = "fosrl/gerbil:latest";
      volumes = [
        "/home/kel/compose2nix/config:/var/config:rw"
      ];
      ports = [
        "51820:51820/udp"
        "21820:21820/udp"
        "443:443/tcp"
        "80:80/tcp"
      ];
      cmd = ["--reachableAt=http://gerbil:3003" "--generateAndSaveKeyTo=/var/config/key" "--remoteConfig=http://pangolin:3001/api/v1/"];
      dependsOn = ["pangolin"];
      log-driver = "journald";
      extraOptions = [
        "--cap-add=NET_ADMIN"
        "--cap-add=SYS_MODULE"
        "--network-alias=gerbil"
        "--network=pangolin"
      ];
    };

    "pangolin" = {
      image = "fosrl/pangolin:latest";
      volumes = [
        "/etc/oci.cont/pangolin/config:/app/config:rw"
        "pangolin-data:/var/dynamic:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--health-cmd=[\"curl\", \"-f\", \"http://localhost:3001/api/v1/\"]"
        "--health-interval=3s"
        "--health-retries=15"
        "--health-timeout=3s"
        "--network-alias=pangolin"
        "--network=pangolin"
      ];
    };

    "traefik" = {
      image = "traefik:v3.4.0";
      volumes = [
        "/etc/oci.cont/pangolin/config/letsencrypt:/letsencrypt:rw"
        "/etc/oci.cont/pangolin/config/traefik:/etc/traefik:ro"
        "pangolin-data:/var/dynamic:ro"
      ];
      cmd = ["--configFile=/etc/traefik/traefik_config.yml"];
      dependsOn = [
        "gerbil"
        "pangolin"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=container:gerbil"
      ];
    };
  };
}
