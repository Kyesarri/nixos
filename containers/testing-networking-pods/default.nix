# https://discourse.nixos.org/t/podman-containers-dns/26820/3
# above example was not working, tweaked some configs, configured macvlan for single container
# may be a good start for a pod with nginx being the only entry into the pod
{pkgs, ...}: {
  systemd.services.pod-cloud = {
    description = "Start podman 'nextcloud' pod";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    requiredBy = ["podman-mariadb.service" "podman-nextcloud.service" "podman-redis.service"];
    unitConfig = {
      RequiresMountsFor = "/run/containers";
    };
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "-${pkgs.podman}/bin/podman pod create cloud";
    };
    path = [pkgs.zfs pkgs.podman];
  };
  virtualisation.oci-containers.containers = {
    nextcloud = {
      image = "nextcloud:latest";
      autoStart = true;
      dependsOn = ["mariadb" "redis"];
      environment = {
        PUID = "1000";
        PGID = "1000";
        MYSQL_HOST = "127.0.0.1";
        REDIS_HOST = "127.0.0.1";

        TRUSTED_PROXIES = "10.88.0.1/24";
        NEXTCLOUD_TRUSTED_DOMAINS = "nextcloud.home";
        MAIL_DOMAIN = "nextcloud.home";
        OVERWRITEHOST = "nextcloud.home";
        OVERWRITEPROTOCOL = "http";
        OVERWRITECLIURL = "nextcloud.home";

        PHP_MEMORY_LIMIT = "2G";
        PHP_UPLOAD_LIMIT = "2G";
      };
      extraOptions = [
        "--device=/dev/dri"
        "--init=true"
        "--pod=cloud"
        "--network=macvlan_lan"
        "--ip=192.168.87.252"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.nextcloud.rule=Host(`nextcloud.home`)"
        "--label=traefik.http.routers.nextcloud.entrypoints=websecure"
        "--label=traefik.http.routers.nextcloud.tls.certResolver=le"
        "--label=traefik.http.routers.nextcloud.middlewares=headers,nextcloud-redirectregex@file"
        "--label=traefik.http.services.nextcloud.loadbalancer.server.port=80"

        "--sysctl=net.ipv4.ip_unprivileged_port_start=80"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/etc/oci.cont/nextcloud-local/html:/var/www/html"
        "/etc/oci.cont/nextcloud-local/data:/data"
      ];
    };

    redis = {
      image = "docker.io/library/redis:latest";
      autoStart = true;
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      cmd = ["redis-server" "--save" "59" "1" "--loglevel" "warning"];
      extraOptions = ["--pod=cloud"];
      volumes = [
        "/etc/oci.cont/redis/data:/data"
      ];
    };

    mariadb = {
      image = "docker.io/library/mariadb:latest";
      autoStart = true;
      cmd = ["--transaction-isolation=READ-COMMITTED" "--log-bin=msqyld-bin" "--binlog-format=ROW"];
      extraOptions = ["--pod=cloud"];
      volumes = [
        "/etc/oci.cont/mariadb-nextcloud/mysql:/var/lib/mysql"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
        MYSQL_PASSWORD = "password";
        MYSQL_ROOT_PASSWORD = "rootpassword";
      };
    };
  };
}
