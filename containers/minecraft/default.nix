{
  secrets,
  lib,
  ...
}: let
  contName = "minecraft";
  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}''; # & chown 9001:9001 ${toString dir1}

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "marctv/minecraft-papermc-server:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
    ];

    # environment = {
    #   PUID = "9001";
    #   PGID = "9001";
    # };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.minecraft}"
    ];
  };
}
