# un-used for now - incomplete need to work out more container networking
## before i start making *more* unworking containers :)
let
  hostName = "codeproject";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [32168 8081];
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "codeproject/ai-server";
      ports = ["32168:32168" "8081:80"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.docker/${hostName}/data:/etc/codeproject/ai"
        "/home/${spaghetti.user}/.docker/${hostName}/modules:/app/modules"
      ];
      extraOptions = [];
    };
  }
