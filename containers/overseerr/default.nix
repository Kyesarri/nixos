{
  secrets,
  lib,
  ...
}: let
  contName = "overseerr";
  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = " lscr.io/linuxserver/overseerr:latest";

    volumes = [
      "/run/dbus:/run/dbus:ro"
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.overseerr}"
    ];
  };
}
/*
services:
  overseerr:
    image: lscr.io/linuxserver/overseerr:latest
    container_name: overseerr
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - /path/to/overseerr/config:/config
    ports:
      - 5055:5055
    restart: unless-stopped
*/

