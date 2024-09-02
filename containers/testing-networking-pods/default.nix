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
  /*
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "zfs";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";
    };
  };
  */
  virtualisation.oci-containers.containers = {
    nextcloud = {
      image = "nextcloud:local";
      autoStart = true;
      user = "1000:100";
      dependsOn = ["mariadb" "redis"];
      environment = {
        MYSQL_HOST = "127.0.0.1";
        REDIS_HOST = "127.0.0.1";
        TRUSTED_PROXIES = "10.88.0.1/24";
        NEXTCLOUD_TRUSTED_DOMAINS = "my.domain";
        MAIL_DOMAIN = "my.domain";
        OVERWRITEHOST = "my.domain";
        OVERWRITEPROTOCOL = "https";
        OVERWRITECLIURL = "my.domain";
        PHP_MEMORY_LIMIT = "2G";
        PHP_UPLOAD_LIMIT = "2G";
      };
      extraOptions = [
        "--device=/dev/dri"
        "--init=true"
        "--pod=cloud"
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.nextcloud.rule=Host(`my.domain`)"
        "--label=traefik.http.routers.nextcloud.entrypoints=websecure"
        "--label=traefik.http.routers.nextcloud.tls.certResolver=le"
        "--label=traefik.http.routers.nextcloud.middlewares=headers,nextcloud-redirectregex@file"
        "--label=traefik.http.services.nextcloud.loadbalancer.server.port=80"
        "--sysctl=net.ipv4.ip_unprivileged_port_start=80"
      ];
      volumes = ["nextcloud_config:/var/www/html" "/mnt/media:/data"];
    };
    redis = {
      image = "docker.io/library/redis:latest";
      autoStart = true;
      user = "1000:100";
      cmd = ["redis-server" "--save" "59" "1" "--loglevel" "warning"];
      extraOptions = ["--pod=cloud"];
      volumes = ["redis_data:/data"];
    };
    mariadb = {
      image = "docker.io/library/mariadb:latest";
      autoStart = true;
      user = "mysql:mysql";
      cmd = ["--transaction-isolation=READ-COMMITTED" "--log-bin=msqyld-bin" "--binlog-format=ROW"];
      extraOptions = ["--pod=cloud"];
      volumes = ["mariadb_data:/var/lib/mysql"];
      environment = {
        MYSQL_DATABASE = "nextcloud";
        MYSQL_USER = "nextcloud";
        MYSQL_PASSWORD = "password";
        MYSQL_ROOT_PASSWORD = "rootpassword";
      };
    };
  };
}
