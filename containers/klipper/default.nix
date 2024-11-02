{
  secrets,
  lib,
  ...
}: let
  contName = "klipper";
  dir1 = "/etc/oci.cont/${contName}/run";
  dir2 = "/etc/oci.cont/${contName}/config";
in {
  system.activationScripts.makeCodeProjectDir =
    lib.stringAfter ["var"]
    ''mkdir -v -p ${toString dir1} & mkdir -v -p ${toString dir2} & chown -R 1000:1000 ${toString dir1}'';

  environment.etc = {
    "oci.cont/${contName}/config/printer.cfg" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./printer.cfg;
    };
  };

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "mkuf/klipper:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/opt/printer_data/run/"
      "/dev:/dev"
      "${toString dir2}:/opt/printer_data/config/"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      ENABLE_MJPG_STREAMER = "true";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      # "--device=/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0:/dev/ttyUSB0"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.klipper}"
      "--privileged"
    ];
  };
}
