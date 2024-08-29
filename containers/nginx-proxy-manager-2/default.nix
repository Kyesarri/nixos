{
  spaghetti,
  secrets,
  lib,
  ...
}: let
  hostName = "nginx-proxy-manager-2";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/data";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/letsencrypt";
in {
  system.activationScripts.makeNginx2Dir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} ${toString dir2} & chown 1000:1000 ${toString dir1} & chown 1000:1000 ${toString dir2}'';

  virtualisation.oci-containers.containers.${hostName} = {
    hostname = "${hostName}";

    autoStart = true;

    image = "docker.io/jc21/nginx-proxy-manager:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
      "${toString dir2}:/etc/letsencrypt"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.nginx-2}"
    ];
  };
}
