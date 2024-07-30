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
    "oci.cont/${contName}/proxies.yml".text = ''
      # This is the domain that players enter in their game client.
      # You can have multiple domains here or just one.
      # Currently this holds just a wildcard character as a domain
      # meaning that is accepts every domain that a player uses.
      # Supports '*' and '?' wildcards in the pattern string.
      #
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
      INFRARED_PROXIES_DIR = "proxies.yml";
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
