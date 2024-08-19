{secrets, ...}: let
  contName = "ustreamer";
in {
  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "mkuf/ustreamer:latest";

    cmd = [
      "--host=${toString secrets.ip.ustreamer}"
      "--port=8080"
      "-f 30"
    ];

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--privileged"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.ustreamer}"
      "--device=/dev/video0:/dev/video0"
    ];
  };
}
