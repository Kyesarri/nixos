let
  hostName = "codeproject";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [32168];
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "codeproject/ai-server";
      ports = ["32168:32168"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.docker/${hostName}/data:/etc/codeproject/ai"
        "/home/${spaghetti.user}/.docker/${hostName}/modules:/app/modules"
      ];
    };
  }
