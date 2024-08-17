{
  secrets,
  lib,
  ...
}: let
  contName = "netbird";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "netbirdio/netbird:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/netbird"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.netbird}"
    ];
  };
}
