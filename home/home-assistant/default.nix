{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [8123];
  };

  # enable docker
  virtualisation.docker = {enable = true;};

  # adds docker-compose to system packages
  environment.systemPackages = with pkgs; [docker-compose intel-gpu-tools];

  virtualisation.oci-containers = {
    backend = "docker"; # or podman
    #
    home-assistant = {
      hostname = "haos-nix-serv";
      autoStart = true;
      image = "ghcr.io/home-assistant/home-assistant:stable";
      ports = [
        "8123:8123"
      ];
      volumes = ["/home/${spaghetti.user}/.docker/emqx:/opt/emqx/data"];
      environment = {};
    };
  };
}
#home-manager.users.${spaghetti.user} = {
#  # frigate config.yml symlink, easier to edit in codeium as a .yml vs pure nix
#  home.file.".docker/frigate/config.yml" = {
#    source = ./config.yml;
#  };
#};
/*
services:
homeassistant:
  container_name: homeassistant
  image: "ghcr.io/home-assistant/home-assistant:stable"
  volumes:
    - /PATH_TO_YOUR_CONFIG:/config
    - /etc/localtime:/etc/localtime:ro
    - /run/dbus:/run/dbus:ro
  restart: unless-stopped
  privileged: true
  network_mode: host
*/

