{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [];
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
