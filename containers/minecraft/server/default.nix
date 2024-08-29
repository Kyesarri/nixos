{
  secrets,
  lib,
  ...
}: let
  contName = "minecraft";
  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  environment.etc = {
    "oci.cont/${contName}/server.properties" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./server.properties;
    };

    "oci.cont/${contName}/config/paper-global.yml" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./paper-global.yml;
    };
  };

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
