{
  secrets,
  lib,
  ...
}: let
  contName = "infrared";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  # create symlinks in /etc - not sure if we can only write to paths relative to /etc
  # symlink file from nix tree to our container dir
  environment.etc."oci.cont/${contName}/favicon.png".source = ./favicon.png;

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/minekube/gate:latest";

    environment = {
      domain = "${toString secrets.domain.minecraft}";
      server1 = "${toString secrets.ip.minecraft}";
    };

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/home/kel/nixos/containers/minecraft/config.yml:/config.yml"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.gate}"
    ];
  };
}
