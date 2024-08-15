{
  lib,
  secrets,
  ...
}: let
  contName = "double-take";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "skrashevich/double-take";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/.storage"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.doubletake}"
    ];
  };
}
