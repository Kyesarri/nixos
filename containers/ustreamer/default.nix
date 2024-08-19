{
  lib,
  secrets,
  ...
}: let
  contName = "ustreamer";
  dir1 = "/dev/video0:/dev/video0";
in {
  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "mkuf/ustreamer:latest";

    cmd = ["--host=0.0.0.0" "--port=80" "-f 30"];

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.ustreamer}"
    ];
  };
}
