{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "codeproject";
  webPort = 32168;
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/codeproject/ai";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/app/modules";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -p ${toString dir1} ${toString dir2}
  '';

  networking.firewall.allowedTCPPorts = [32168];
  virtualisation.oci-containers.containers.${hostName} = {
    hostname = "${hostName}";
    autoStart = true;
    image = "codeproject/ai-server:latest";
    ports = ["${toString webPort}:${toString webPort}"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/codeproject/ai"
      "${toString dir2}:/app/modules"
    ];
    extraOptions = [
      "--device=/dev/apex_0:/dev/apex_0"
    ];
  };
}
