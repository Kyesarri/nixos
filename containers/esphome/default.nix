{
  secrets,
  lib,
  ...
}: let
  contName = "esphome";
  dir1 = "/etc/oci.cont/${contName}/config";
in {
  system.activationScripts.makeESPHomeDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    image = "ghcr.io/esphome/esphome:stable";
    autoStart = true;
    volumes = [
      "${toString dir1}:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.esphome}"
    ];
  };
}
