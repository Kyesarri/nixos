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

    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "lscr.io/linuxserver/plex:latest";
      ports = ["${toString webPort}:${toString webPort}"]; # toString is hot!
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/dev/dri:/dev/dri"

        "/hdda/movies:/movies/hdda"
        "/hddb/movies:/movies/hddb"
        "/hddc/movies:/movies/hddc"
        "/hddd/movies:/movies/hddd"
        "/hdde/movies:/movies/hdde"

        "/hdda/tv_shows:/tv_shows/hdda"
        "/hddb/tv_shows:/tv_shows/hddb"
        "/hddc/tv_shows:/tv_shows/hddc"
        "/hddd/tv_shows:/tv_shows/hddd"
        "/hdde/tv_shows:/tv_shows/hdde"

        "/home/${spaghetti.user}/.containers/${hostName}:/config"
      ];
      environment = {};
      extraOptions = ["--privileged"];
    };
  }
