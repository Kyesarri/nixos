{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  /*
    networking.firewall = {
    allowedTCPPorts = [];
    allowedUDPPorts = [];
  };
  */
  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      #
      transmission = {
        hostname = "transmission-nix-serv";
        autoStart = true;
        image = "lscr.io/linuxserver/transmission:latest";
        ports = [
          "9091:9091"
          "51413:51413"
          "51413:51413/udp"
        ];
        volumes = [
          "/home/${spaghetti.user}/.docker/transmission:/config"
          # TODO "/path/to/downloads:/downloads"
          # TODO "/path/to/watch/folder:/watch"
          "/etc/localtime:/etc/localtime:ro"
          "/etc/timezone:/etc/timezone:ro"
        ];
        /*
        environment = {
          PUID = 1000;
          PGID = 1000;
        };
        */
        extraOptions = [
          "--ip=192.168.87.11/24"
        ];
      };
      #
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
        /*
          environment = {
          PUID = 1000;
          PGID = 1000;
        };
        */
        extraOptions = [
          "--ip=192.168.87.12/24"
        ];
      };
    };
  };
}
