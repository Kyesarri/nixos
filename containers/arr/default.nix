{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  contName = "arr";
  dir1 = "/etc/oci.cont/${contName}";
  # TODO = "lots";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/home-assistant/home-assistant:stable";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {};

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.haos}"
    ];
  };
}
