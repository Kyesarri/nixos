{
  secrets,
  lib,
  ...
}: let
  contName = "syncthing"; # container name
  dir1 = "/etc/oci.cont/${contName}"; # root dir
  dir2 = "/etc/oci.cont/${contName}/config"; # config
  dir3 = "/etc/oci.cont/${contName}/storage"; # main storage
in {
  # create directories, change owner
  system.activationScripts.makeCodeProjectDir =
    lib.stringAfter ["var"] ''
      mkdir -v -p ${toString dir1} & mkdir -v -p ${toString dir2} & mkdir -v -p ${toString dir3} & chown -R 1000:1000 ${toString dir1}'';

  # container config
  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "lscr.io/linuxserver/syncthing:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir2}:/config"
      "${toString dir3}:/storage"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--dns=${secrets.ip.adguard}"
      "--ip=${secrets.ip.syncthing}"
    ];
  };
}
