{secrets, ...}: let
  contName = "peanut";
in {
  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "brandawg93/peanut:latest";

    volumes = ["/etc/localtime:/etc/localtime:ro"];

    environment = {
      PUID = "1000";
      PGID = "1000";
      NUT_HOST = "${toString secrets.ip.erying}";
      NUT_PORT = "3493";
      WEB_PORT = "8080";
      USERNAME = "upsmon";
      PASSWORD = "upsmon_pass";
      WEB_HOST = "localhost";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.peanut}"
    ];
  };
}
