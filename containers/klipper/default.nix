{
  secrets,
  lib,
  ...
}: let
  contName = "klipper";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "mkuf/klipper:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}/run:/opt/printer_data/run/"
      "/dev:/dev"
      # "/printer.cfg:/opt/printer_data/config/printer.cfg"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      ENABLE_MJPG_STREAMER = "true";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--device=/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0:/dev/ttyUSB0"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.klipper}"
      "--privileged"
    ];
  };
}
