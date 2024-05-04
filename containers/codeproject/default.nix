{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "codeproject";
  webPort = 32168;
  # dir1 = "/home/${spaghetti.user}/.containers/${hostName}/usr/lib/x86_64-linux-gnu";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/codeproject/ai";
  dir3 = "/home/${spaghetti.user}/.containers/${hostName}/app";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -p ${toString dir2} ${toString dir3} && echo volumes created for ${hostName}
  ''; #    mkdir -p ${toString dir1} ${toString dir2} ${toString dir3} && echo volumes created for ${hostName}

  networking.firewall.allowedTCPPorts = [32168];
  virtualisation.oci-containers.containers.${hostName} = {
    hostname = "${hostName}-nix-serv";
    autoStart = true;
    image = "codeproject/ai-server:latest";
    ports = ["${toString webPort}:${toString webPort}"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      # "${toString dir1}:/usr/lib/x86_64-linux-gnu"
      "${toString dir2}:/etc/codeproject/ai"
      "${toString dir3}:/app"
    ];
    extraOptions = [
      "--device=/dev/apex_0:/dev/apex_0"
    ];
  };
}
