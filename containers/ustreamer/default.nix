{secrets, ...}: let
  contName = "ustreamer";
  dir1 = "/dev/video0:/dev/video0";
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
      "${toString dir1}"
    ];

    environment = {
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--privileged"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.ustreamer}"
    ];
  };
}
