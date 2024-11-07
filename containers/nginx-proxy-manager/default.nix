{
  spaghetti,
  secrets,
  lib,
  ...
}: let
  hostName = "nginx-proxy-manager";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/data";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/letsencrypt";
in {
  system.activationScripts.makeNginxDir = lib.stringAfter ["var"] ''mkdir -v -m 777 -p ${toString dir1} ${toString dir2}''; # shitty perms, "temp" workaround

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
      "--network=fweedee"
      "--network=macvlan_lan -ip=${secrets.ip.nginx}"
    ];
  };
}
