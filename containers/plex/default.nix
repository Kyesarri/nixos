let
  hostName = "plex";
  webPort = 32400;
in
  {
    spaghetti,
    lib,
    ...
  }: {
    system.activationScripts.makePlexDir =
      lib.stringAfter ["var"]
      ''mkdir -p /home/${spaghetti.user}/.containers/${hostName}'';

    networking.firewall.allowedTCPPorts = [32400];
    networking.firewall.allowedUDPPorts = [32400];

    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";

      autoStart = true;

      image = "lscr.io/linuxserver/plex:latest";

      ports = ["${toString webPort}:${toString webPort}"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/dev/dri:/dev/dri"

        "/hdda/movies:/movies/hdda"
        "/hddb/movies:/movies/hddb"
        "/hddc/movies:/movies/hddc"
        "/hddd/movies:/movies/hddd"
        "/hdde/movies:/movies/hdde"
        "/hddf/movies:/movies/hddf"
        "/hddg/movies:/movies/hddg"
        "/hddh/movies:/movies/hddh"
        "/hddi/movies:/movies/hddi"

        "/hdda/tv_shows:/tv_shows/hdda"
        "/hddb/tv_shows:/tv_shows/hddb"
        "/hddc/tv_shows:/tv_shows/hddc"
        "/hddd/tv_shows:/tv_shows/hddd"
        "/hdde/tv_shows:/tv_shows/hdde"
        "/hddf/tv_shows:/tv_shows/hddf"
        "/hddg/tv_shows:/tv_shows/hddg"
        "/hddh/tv_shows:/tv_shows/hddh"
        "/hddi/tv_shows:/tv_shows/hddi"

        "/home/${spaghetti.user}/.containers/${hostName}:/config"
      ];
      environment = {
        PUID = "1000";
        PGID = "1000";
      };
      extraOptions = ["--privileged"];
    };
  }
