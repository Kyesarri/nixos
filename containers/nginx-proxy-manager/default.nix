{
  secrets,
  lib,
  ...
}: let
  contName = "nginx-proxy-manager";
  dir1 = "/etc/oci.cont/${contName}/data";
  dir2 = "/etc/oci.cont/${contName}/letsencrypt";
in {
  system.activationScripts.makeNginxDir =
    lib.stringAfter
    ["var"] ''mkdir -v -p ${dir1} ${dir2} & chown -R 1000:1000 ${dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "docker.io/jc21/nginx-proxy-manager:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${dir1}:/data"
      "${dir2}:/etc/letsencrypt"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan:ip=${secrets.ip.nginx}"
    ];
  };
}
