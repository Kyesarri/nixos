{
  pkgs,
  lib,
  ...
}: {
  # root target
  systemd.targets."podman-headscale-root" = {
    unitConfig = {Description = "root target";};
    wantedBy = ["multi-user.target"];
  };
  # containers
  systemd.services."podman-headscale" = {
    serviceConfig = {Restart = lib.mkOverride 90 "always";};
    after = ["podman-network-internal.service"];
    requires = ["podman-network-internal.service"];
    partOf = ["podman-headscale-root.target"];
    wantedBy = ["podman-headscale-root.target"];
  };
  systemd.services."podman-headscale-postgres" = {
    serviceConfig = {Restart = lib.mkOverride 90 "always";};
    after = ["podman-network-internal.service"];
    requires = ["podman-network-internal.service"];
    partOf = ["podman-headscale-root.target"];
    wantedBy = ["podman-headscale-root.target"];
  };
  # volumes

  virtualisation.oci-containers.containers = {
    # headscale
    "headscale" = {
      image = "headscale/headscale:latest";
      volumes = [
        "headscale:/etc/headscale:rw"
        "headscale-data:/var/lib/headscale:rw"
      ];
      ports = [
        # "9090:9090/tcp"
        # "3478:3478/udp"
      ];
      cmd = ["serve"];
      labels = {
        /*
        "traefik.enable" = "true";
        "traefik.http.routers.headscale.entrypoints" = "websecure";
        "traefik.http.routers.headscale.rule" = "Host(`headscale.mydomain.com`)";
        "traefik.http.routers.headscale.tls.certresolver" = "cloudflare";
        "traefik.http.routers.headscale.tls.domains[0].main" = "mydomain.com";
        "traefik.http.routers.headscale.tls.domains[0].sans" = "*.mydomain.com";
        "traefik.http.services.headscale.loadbalancer.server.port" = "8080";
        */
      };
      dependsOn = [
        "headscale-postgres"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=headscale"
        "--network=internal"
      ];
    };

    # headscale-db
    "headscale-postgres" = {
      image = "postgres:14";
      environment = {
        "POSTGRES_DB" = "headscale";
        "POSTGRES_PASSWORD" = "headscalepw";
        "POSTGRES_USER" = "headscale";
      };
      volumes = [
        "headscale-pg:/var/lib/postgresql/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network-alias=headscale-postgres"
        "--network=internal"
      ];
    };
  };
}
