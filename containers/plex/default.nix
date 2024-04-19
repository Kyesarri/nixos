let
  hostName = "plex";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [32400];

    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "lscr.io/linuxserver/plex:latest";
      ports = [];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/etc/timezone:/etc/timezone:ro"

        "/dev/dri:/dev/dri"

        "/hddb/movies:/movies/hddb"
        "/hddc/movies:/movies/hddc"
        "/hddd/movies:/movies/hddd"
        "/hdde/movies:/movies/hdde"

        "/hddb/tv_shows:/tv_shows/hddb"
        "/hddc/tv_shows:/tv_shows/hddc"
        "/hddd/tv_shows:/tv_shows/hddd"
        "/hdde/tv_shows:/tv_shows/hdde"

        "/home/${spaghetti.user}/.docker/${hostName}:/config"
      ];
      environment = {};
      extraOptions = [
        "--network=host"
        "--privileged"
      ];
    };
  }
