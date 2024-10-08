{
  lib,
  secrets,
  ...
}: let
  contName = "readarr";

  dir1 = "/etc/oci.cont/arr/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "ghcr.io/linuxserver/${toString contName}:develop"; # changed to develop branch, no latest for readarr

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.readarr}"
    ];
  };
}
