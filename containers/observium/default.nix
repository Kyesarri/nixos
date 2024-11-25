{
  lib,
  secrets,
  ...
}: let
  contName = "observium";
  dir1 = "/etc/oci.cont/${contName}/logs";
  dir2 = "/etc/oci.cont/${contName}/rrd";
  dir3 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"] ''mkdir -v -p ${dir1} ${dir2} ${dir3} & chown -R 1000:1000 ${dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "mbixtech/observium";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${dir1}:/opt/observium/logs"
      "${dir2}:/opt/observium/rrd"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      OBSERVIUM_ADMIN_USER = "admin";
      OBSERVIUM_ADMIN_PASS = "passw0rd";
      OBSERVIUM_DB_HOST = "db";
      OBSERVIUM_DB_NAME = "observium";
      OBSERVIUM_DB_USER = "observium";
      OBSERVIUM_DB_PASS = "passw0rd";
      OBSERVIUM_BASE_URL = "http://${secrets.ip.observium}:8888";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=macvlan_lan:ip=${secrets.ip.observium}"
    ];
    #TODO add database container / make a pod
  };
}
