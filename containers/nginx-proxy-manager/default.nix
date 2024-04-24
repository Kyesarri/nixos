let
  hostName = "nginx-proxy-manager";
in
  {
    spaghetti,
    config,
    pkgs,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [80 81 443];
    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}";
      autoStart = true;
      image = "docker.io/jc21/nginx-proxy-manager:latest";
      ports = ["80:80" "192.168.87.1:81:81" "443:443"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.docker/${hostName}/data:/data"
        "/home/${spaghetti.user}/.docker/${hostName}/letsencrypt:/etc/letsencrypt"
      ];
      extraOptions = [
        # "--network=host"
        # "--network=pod-net"
      ];
    };
  }
