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
      allowedTCPPorts = [1001 1002 1003 1004 18083];
      # allowedUDPPorts = [18083];
    };
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "ghcr.io/emqx/emqx:latest";
      ports = [
        "1001:1883/tcp"
        "1002:8083/tcp"
        "1003:8084/tcp"
        "1004:8883/tcp"
        "18083:18083/tcp"
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
      extraOptions = [];
    };
  }
