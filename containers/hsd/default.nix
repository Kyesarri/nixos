{
  secrets,
  lib,
  ...
}: let
  contName = "hsd";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/handshake-org/hsd:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/root/.hsd"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.hsd}"
      "--api-key=${secrets.hsd.api}"
    ];
  };
}
