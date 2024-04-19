let
  hostName = "emqx";
in
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
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
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
        "/home/${spaghetti.user}/.docker/${hostName}/data:/opt/emqx/data"
        "/home/${spaghetti.user}/.docker/${hostName}/etc:/opt/emqx/etc"
        "/home/${spaghetti.user}/.docker/${hostName}/log:/opt/emqx/log"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        # EMQX_NODE_NAME = "${hostName}-nix-serv";
        # EMQX_CLUSTER__DISCOVERY_STRATEGY = "static";
        # EMQX_CLUSTER__STATIC__SEEDS = "emqx-nix-serv";
      };
      extraOptions = [
        "--network=host"
      ];
    };
  }
