{
  secrets,
  lib,
  ...
}: let
  contName = "i2pd";

  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";

    autoStart = true;

    image = "purplei2p/i2pd:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${dir1}/.i2pd:/home/.i2pd/"
      "${dir1}/i2pd:/home/i2pd/"
    ];

    cmd = ["--http.address ${toString secrets.ip.i2pd}"];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.i2pd}"
    ];
  };
}
