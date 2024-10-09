{
  secrets,
  lib,
  ...
}: let
  contName = "ghost";

  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & mkdir -v -p ${toString dir1}/ghost & mkdir -v -p ${toString dir1}/db & chown -R 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghost:5-alpine";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}/ghost:/var/lib/ghost/content"
    ];
    environment = {
      database__client = "mysql";
      database__connection__host = "${toString secrets.ip.ghost-db}";
      database__connection__user = "${toString secrets.user.ghost-db}";
      database__connection__password = "${toString secrets.password.ghost-db}";
      database__connection__database = "ghost";
      url = "${secrets.domain.main}";
    };
    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.ghost}"
    ];
  };

  virtualisation.oci-containers.containers."${contName}.db" = {
    hostname = "${contName}-db";
    autoStart = true;
    image = "mysql:8";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}/db:/var/lib/mysql"
    ];
    environment = {
      MYSQL_ROOT_PASSWORD = "${toString secrets.password.ghost-db-root}";
      MYSQL_DATABASE = "ghost";
      MYSQL_USER = "${toString secrets.user.ghost-db}";
      MYSQL_PASSWORD = "${toString secrets.password.ghost-db}";
    };
    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.ghost-db}"
    ];
  };
}
