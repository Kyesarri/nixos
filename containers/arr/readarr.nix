{
  spaghetti,
  secrets,
  # config,
  # pkgs,
  lib,
  ...
}: let
  contName = "readarr";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/linuxserver/${toString contName}:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--pod=arr_pod"
      "--ip=10.1.1.14"

      # "--network=macvlan_lan"
      # "--ip=${secrets.ip.haos}"
    ];
  };
}
