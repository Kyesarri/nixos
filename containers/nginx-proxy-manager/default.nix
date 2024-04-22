{
  spaghetti,
  config,
  pkgs,
  ct,
  nginx,
  ...
}: {
  networking.firewall = {allowedTCPPorts = [80 81 443];};
  virtualisation.oci-containers.containers.${ct.nginx.hostName} = {
    hostname = "${ct.nginx.hostName}";
    autoStart = true;
    image = "docker.io/jc21/nginx-proxy-manager:latest";
    ports = ["80:80" "81:81" "443:443"];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/home/${spaghetti.user}/.docker/${ct.nginx.hostName}/data:/data"
      "/home/${spaghetti.user}/.docker/${ct.nginx.hostName}/letsencrypt:/etc/letsencrypt"
    ];
  };
}
/*
version: '3.8'
services:
  app:
    image: 'docker.io/jc21/nginx-proxy-manager:latest'
    restart: unless-stopped
    ports:
      - '80:80'
      - '81:81'
      - '443:443'
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
*/

