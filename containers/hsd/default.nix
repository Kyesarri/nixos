{
  secrets,
  lib,
  ...
}: let
  contName = "hsd";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/handshake-org/hsd:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/root/.hsd"
    ];

    environment = {};

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.hsd}"
      "--api-key=foo"
    ];
  };
}
/*
docker run --name hsd
    --publish 12037:12037
    --volume $HOME/.hsd:/root/.hsd
    hsd:$VERSION-$COMMIT
    --http-host 0.0.0.0
    --api-key=foo
*/

