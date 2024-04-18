{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [1883 8083 8084 8883 18083];
    allowedUDPPorts = [18083];
  };
  virtualisation.oci-containers.containers.emqx = {
    hostname = "emqx-nix-serv";
    autoStart = true;
    image = "ghcr.io/emqx/emqx:latest";
    ports = [
      "1883:1883"
      "8083:8083"
      "8084:8084"
      "8883:8883"
      "18083:18083"
    ];
    volumes = [
      "/home/${spaghetti.user}/.docker/emqx/data:/opt/emqx/data"
      "/home/${spaghetti.user}/.docker/emqx/etc:/opt/emqx/etc"
      "/home/${spaghetti.user}/.docker/emqx/log:/opt/emqx/log"
      "/etc/localtime:/etc/localtime:ro"
    ];
    environment = {
      EMQX_NODE_NAME = "emqx-nix-serv";
      EMQX_CLUSTER__DISCOVERY_STRATEGY = "static";
      # EMQX_CLUSTER__STATIC__SEEDS = "emqx-nix-serv";
    };
    extraOptions = [
      "--network=host"
      "--privileged"
    ];
  };
}
