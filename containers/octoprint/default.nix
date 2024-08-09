{
  secrets,
  lib,
  ...
}: let
  contName = "octoprint";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "octoprint/octoprint:latest";

    volumes = [
      # use `python -m serial.tools.miniterm` to see what the name is of the printer, this requires pyserial
      "/dev/ttyUSB0:/dev/ttyUSB0"
      # "/dev/video0:/dev/video0"
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/octoprint"
    ];

    environment = {
      # ENABLE_MJPG_STREAMER = "true";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.octoprint}"
      "--privileged"
    ];
  };
}
