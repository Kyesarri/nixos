{
  lib,
  secrets,
  ...
}: let
  contName = "adguard";

  dir1 = "/etc/oci.cont/${contName}/work";

  dir2 = "/etc/oci.cont/${contName}/conf";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} ${toString dir2} & chown 1000:1000 ${toString dir1} & chown 1000:1000 ${toString dir2}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "adguard/adguardhome:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/opt/adguardhome/work"
      "${toString dir2}:/opt/adguardhome/conf"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--privileged"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.adguard}"
    ];
  };
}
