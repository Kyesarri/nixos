{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [1883 8083 8084 8883 18083];
    allowedUDPPorts = [];
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers.emqx = {
      hostname = "emqx-nix-serv";
      autoStart = true;
      image = "emqx:latest";
      ports = [
        "1883:1883"
        "8083:8083"
        "8084:8084"
        "8883:8883"
        "18083:18083"
      ];
      volumes = ["/home/${spaghetti.user}/.docker/emqx:/opt/emqx/data"];
      environment = {
        EMQX_NODE_NAME = "emqx@nix-serv";
        EMQX_CLUSTER__DISCOVERY_STRATEGY = "static";
      };
    };
  };
}
