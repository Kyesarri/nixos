let
  hostName = "codeproject";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
      mkdir -p /home/${spaghetti.user}/.containers/${hostName}/etc/codeproject/ai &&
      mkdir -p /home/${spaghetti.user}/.containers/${hostName}/app/modules &&
      mkdir -p /home/${spaghetti.user}/.containers/${hostName}/usr/lib/x86_64-linux-gnu
    '';
    networking.firewall.allowedTCPPorts = [32168];
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "codeproject/ai-server:latest";
      ports = ["32168:32168"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.containers/${hostName}/data:/etc/codeproject/ai"
        "/home/${spaghetti.user}/.containers/${hostName}/app/modules:/app/modules"
        "/home/${spaghetti.user}/.containers/${hostName}/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu"
      ];
      extraOptions = [
        "--device=/dev/apex_0:/dev/apex_0"
      ];
    };
  }
