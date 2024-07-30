{
  secrets,
  lib,
  ...
}: let
  contName = "infrared";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  # create symlinks in /etc - not sure if we can only write to paths relative to /etc
  # symlink file from nix tree to our container dir
  environment.etc = {
    "oci.cont/${contName}/favicon.png".source = ./favicon.png;

    "oci.cont/${contName}/proxy/proxy.yml".text = ''
      domains:
        - "${toString secrets.domain.minecraft}"
      addresses:
        - ${toString secrets.ip.minecraft}:25565
    '';
  };

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "haveachin/infrared:latest";

    environment = {
      INFRARED_PROXIES_DIR = "./proxies";
      INFRARED_CONFIG = "config.yml";
    };

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/infrared"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.infrared}"
    ];
  };
}
