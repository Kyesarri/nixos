{
  secrets,
  lib,
  ...
}: let
  contName = "i2pd";
  dir1 = "/etc/oci.cont/${contName}/data";
in {
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"]
    ''
      mkdir -v -p ${toString dir1} certificates destinations &&
      chown -R 1000:1000 ${toString dir1}
    '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "purplei2p/i2pd:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${dir1}:/home/i2pd/data/"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.i2pd}"
    ];
  };
}
