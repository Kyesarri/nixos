{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [8123];
  };
  virtualisation.oci-containers.containers = {
    home-assistant = {
      hostname = "haos-nix-serv";
      autoStart = true;
      image = "ghcr.io/home-assistant/home-assistant:stable";
      ports = ["8123:8123/tcp"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.docker/haos:/config"
      ];
      environment = {};
      extraOptions = [
        "--device=/dev/ttyUSB0"
        # "--network=host"
        "--privileged"
        "--network=pod-net"
      ];
    };
  };
}
