# https://discourse.nixos.org/t/podman-containers-dns/26820
#
# above example was not working, tweaked some configs, configured macvlan for single container
# seems like it all works out of the box, having only the container i want exposed while the remainer
# exist in the pod
{pkgs, ...}: {
  # create a pod named cloud
  systemd.services.pod-cloud = {
    description = "Start podman 'nextcloud' pod";
    # don't start without network-online being up
    wants = ["network-online.target"];
    after = ["network-online.target"];
    # our containers require pod-cloud to be up before they start
    requiredBy = ["podman-mariadb.service" "podman-nextcloud.service" "podman-redis.service"];
    # unsure, might not be required?
    unitConfig = {
      RequiresMountsFor = "/run/containers";
    };
    # script to run (create the pod)
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "-${pkgs.podman}/bin/podman pod create cloud";
    };
    path = [pkgs.zfs pkgs.podman];
  };
  virtualisation.oci-containers.containers = {
    # first container
    nextcloud = {
      image = "nextcloud:latest";
      autoStart = true;
      dependsOn = ["mariadb" "redis"];
      environment = {
        PUID = "1000"; # i prefer to have PUID / PGID set in env
        PGID = "1000";
        MYSQL_HOST = "127.0.0.1";
        REDIS_HOST = "127.0.0.1";
        TRUSTED_PROXIES = "10.88.0.1/24"; # is this the host of the containers... idk yet
        NEXTCLOUD_TRUSTED_DOMAINS = "nextcloud.home";
        MAIL_DOMAIN = "nextcloud.home";
        OVERWRITEHOST = "nextcloud.home";
        OVERWRITEPROTOCOL = "https";
        OVERWRITECLIURL = "nextcloud.home";

        PHP_MEMORY_LIMIT = "2G";
        PHP_UPLOAD_LIMIT = "2G";
      };
      extraOptions = [
        "--device=/dev/dri"
        "--init=true"
        "--pod=cloud" # add container to pod
        "--network=macvlan_lan" # add device to the macvlan
        "--ip=192.168.87.252" # add static ip on our network
        "--label=traefik.enable=true"
        "--label=traefik.http.routers.nextcloud.rule=Host(`nextcloud.home`)"
        "--label=traefik.http.routers.nextcloud.entrypoints=websecure"
        "--label=traefik.http.routers.nextcloud.tls.certResolver=le"
        "--label=traefik.http.routers.nextcloud.middlewares=headers,nextcloud-redirectregex@file"
        "--label=traefik.http.services.nextcloud.loadbalancer.server.port=80"

        "--sysctl=net.ipv4.ip_unprivileged_port_start=80"
      ];
      volumes = [
        "/etc/localtime:/etc/localtime:ro" # read time from host, read only
        "/etc/oci.cont/nextcloud-local/html:/var/www/html" # directory
        "/etc/oci.cont/nextcloud-local/data:/data" # directory
      ];
    };

    # seccond container
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

    # third container
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
