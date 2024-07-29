{
  secrets,
  lib,
  ...
}: let
  contName = "minecraft";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "itzg/minecraft-server";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      ELUA = "TRUE";
      TYPE = "QUILT";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.minecraft}"
    ];
  };
}
