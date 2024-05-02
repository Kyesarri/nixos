let
  hostName = "nginx-proxy-manager";
  webPort = 81;
in
  {
    spaghetti,
    config,
    pkgs,
    lib,
    ...
  }: {
    system.activationScripts.makeNGINXDir =
      lib.stringAfter ["var"]
      ''mkdir -p /home/${spaghetti.user}/.containers/${hostName}/data /home/${spaghetti.user}/.containers/${hostName}/letsencrypt'';

    networking.firewall.allowedTCPPorts = [80 webPort 443];

    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}";
      autoStart = true;
      image = "docker.io/jc21/nginx-proxy-manager:latest";
      ports = ["80:80" "81:81" "443:443"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.containers/${hostName}/data:/data"
        "/home/${spaghetti.user}/.containers/${hostName}/letsencrypt:/etc/letsencrypt"
      ];
      extraOptions = [
        # "--network=host"
        # "--network=pod-net"
      ];
    };
  }
