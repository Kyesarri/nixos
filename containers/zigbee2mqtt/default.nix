{
  lib,
  secrets,
  ...
}: let
  contName = "zigbee2mqtt";
  dir1 = "/etc/oci.cont/${contName}/.data";
  #dir2 = "/etc/oci.cont/${contName}/rrd"; # not sure what to do with this feller - from source       - /run/udev:/run/udev:ro
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  ''; # & chown 1000:1000 ${toString dir2}

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "koenkk/zigbee2mqtt";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/app/data"
      #"${toString dir2}:/opt/observium/rrd"       - /run/udev:/run/udev:ro see above dir2
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.zigbee2mqtt}"
    ];
  };
}
