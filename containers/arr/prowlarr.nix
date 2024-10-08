{
  lib,
  secrets,
  ...
}: let
  contName = "prowlarr";

  dir1 = "/etc/oci.cont/arr/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "ghcr.io/linuxserver/${toString contName}:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.prowlarr}"
    ];
  };
}
