{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [8123];
  };

  virtualisation.docker = {enable = true;};

  environment.systemPackages = with pkgs; [docker-compose intel-gpu-tools];

  virtualisation.oci-containers = {
    backend = "docker";
    #
    containers = {
      home-assistant = {
        hostname = "haos-nix-serv";
        autoStart = true;
        image = "ghcr.io/home-assistant/home-assistant:stable";
        ports = [
          "8123:8123"
        ];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/home/${spaghetti.user}/.docker/haos:/config"
        ];
        environment = {};
        extraOptions = [
          "--device=/dev/ttyUSB0"
          "--network=host"
          "--privileged"
        ];
      };
    };
  };
}
