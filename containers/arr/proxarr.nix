{
  spaghetti,
  secrets,
  # config,
  # pkgs,
  lib,
  ...
}: let
  contName = "proxarr";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "docker.io/jc21/nginx-proxy-manager:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {};

    extraOptions = [
      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.haos}"
    ];
  };
}
