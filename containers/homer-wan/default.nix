{
  secrets,
  lib,
  ...
}: let
  contName = "homer";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "b4bz/homer:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/www/assets"
    ];

    environment = {};

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.homer-wan}"
    ];
  };
}
