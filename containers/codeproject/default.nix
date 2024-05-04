{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "codeproject";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/codeproject/ai";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/app/modules";
  dir3 = "/home/${spaghetti.user}/.containers/${hostName}/usr/lib/x86_64-linux-gnu";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -p ${toString dir1} ${toString dir2} ${toString dir3} && echo volumes created for ${toString hostName}
  '';
  networking.firewall.allowedTCPPorts = [32168];
  virtualisation.oci-containers.containers.${hostName} = {
    hostname = "${hostName}-nix-serv";
    autoStart = true;
    image = "codeproject/ai-server:latest";
    ports = ["32168:32168"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/codeproject/ai"
      "${toString dir2}:/app/modules"
      "${toString dir3}:/usr/lib/x86_64-linux-gnu"
    ];
    extraOptions = [
      "--device=/dev/apex_0:/dev/apex_0"
    ];
  };
}
