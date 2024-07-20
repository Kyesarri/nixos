{
  secrets,
  lib,
  ...
}: let
  contName = "matter";
  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = " ghcr.io/home-assistant-libs/python-matter-server:6.2.2";

    volumes = [
      "/run/dbus:/run/dbus:ro"
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.matter}"
    ];
  };
}
