{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "nginx-proxy-manager";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/data";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/letsencrypt";
in {
  virtualisation.oci-containers.containers.${hostName} = {
    hostname = "${hostName}";
    autoStart = true;
    image = "docker.io/jc21/nginx-proxy-manager:latest";
    # ports = ["80:80" "81:81" "443:443"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
      "${toString dir2}:/etc/letsencrypt"
    ];
    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.nginx}"
      "--pull=always"
    ];
  };
}
