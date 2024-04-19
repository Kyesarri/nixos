let
  hostName = "arr";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall = {
      allowedTCPPorts = [9091 7878];
    };

    virtualisation.oci-containers.containers = {
      transmission = {
        hostname = "transmission-nix-serv";
        autoStart = true;
        image = "lscr.io/linuxserver/transmission:latest";
        ports = [
          "192.168.87.11:9091:9091"
          "51413:51413"
          "51413:51413/udp"
        ];
        volumes = [
          "/home/${spaghetti.user}/.docker/transmission:/config"

          "/hddb:/hddb"
          "/hddc:/hddc"
          "/hddd:/hddd"
          "/hdde:/hdde"
          "/hdde/torrents:/downloads"
          "/hdde/watch:/watch"

          "/etc/localtime:/etc/localtime:ro"
          "/etc/timezone:/etc/timezone:ro"
        ];

        environment = {};

        extraOptions = [
          "PUID=1000"
          "PGID=1000"
          "--network=host"
          "--privileged"
        ];
      };
      #
      /*
      radarr = {
        hostname = "radarr-nix-serv";
        autoStart = true;
        image = "lscr.io/linuxserver/radarr:latest";
        ports = ["7878:7878"];
        volumes = [
          "/home/${spaghetti.user}/.docker/radarr:/config"
          # TODO "/path/to/downloads:/downloads"
          # TODO "/path/to/watch/folder:/watch"
          "/etc/localtime:/etc/localtime:ro"
          "/etc/timezone:/etc/timezone:ro"
        ];

          environment = {
          PUID = 1000;
          PGID = 1000;
        };

        extraOptions = [];
      };
      */
    };
  }
