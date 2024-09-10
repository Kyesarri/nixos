{
  secrets,
  lib,
  ...
}: let
  contName = "orcaslicer";
  dir1 = "/etc/oci.cont.nvme/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "lscr.io/linuxserver/orcaslicer:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/config"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      ENABLE_MJPG_STREAMER = "true";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.orcaslicer}"
      "--privileged"
    ];
  };
}
