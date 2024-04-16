{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [32400];
  };

  virtualisation.docker = {enable = true;};

  environment.systemPackages = with pkgs; [docker-compose];

  virtualisation.oci-containers = {
    backend = "docker";
    #
    containers = {
      plex = {
        hostname = "plex-nix-serv";
        autoStart = true;
        image = "lscr.io/linuxserver/plex:latest";
        ports = [];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/dev/dri:/dev/dri"
          "/hddb/movies:/movies/hddb"
          "/hddc/movies:/movies/hddc"
          "/hddd/movies:/movies/hddd"
          "/hdde/movies:/movies/hdde"

          "/hddb/tv_shows:/tv_shows/hddb"
          "/hddc/tv_shows:/tv_shows/hddc"
          "/hddd/tv_shows:/tv_shows/hddd"
          "/hdde/tv_shows:/tv_shows/hdde"

          "/home/${spaghetti.user}/.docker/plex:/config"
        ];
        environment = {};
        extraOptions = [
          "--network=host"
          "--privileged"
        ];
      };
    };
  };
}
