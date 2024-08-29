{
  lib,
  secrets,
  ...
}: let
  contName = "observium";
  dir1 = "/etc/oci.cont/${contName}/logs";
  dir2 = "/etc/oci.cont/${contName}/rrd";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1} & chown 1000:1000 ${toString dir2}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "mbixtech/observium";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/opt/observium/logs"
      "${toString dir2}:/opt/observium/rrd"
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
      OBSERVIUM_BASE_URL = "http://observium.mbixtech.com:8888";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.observium}"
    ];
  };
}
