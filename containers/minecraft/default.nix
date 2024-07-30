{
  secrets,
  lib,
  ...
}: let
  contName = "minecraft";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "marctv/minecraft-papermc-server:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.minecraft}"
    ];
  };
}
