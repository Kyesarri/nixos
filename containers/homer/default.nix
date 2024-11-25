{
  secrets,
  lib,
  ...
}: let
  contName = "homer";

  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000 ${toString dir1}'';

  environment.etc."oci.cont/${contName}/config.yml" = {
    mode = "644"; # <3
    uid = 1000; # set uid
    gid = 1000; # set gid
    source = ./config.yml; # source file
  };

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
      # "--network=macvlan_lan:ip=${secrets.ip.homer}"
      "--network=podman-backend:ip=${secrets.vlan.erying.homer}"
    ];
  };
}
