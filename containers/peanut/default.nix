{
  secrets,
  lib,
  ...
}: let
  contName = "peanut";
  dir1 = "/etc/oci.cont/${contName}/config";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "brandawg93/peanut:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/app/config"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      NUT_HOST = "${secrets.ip.erying}";
      NUT_PORT = "3493";
      WEB_PORT = "8080";
      USERNAME = "test";
      PASSWORD = "test";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.peanut}"
    ];
  };
}
