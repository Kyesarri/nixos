let
  hostName = "home-assistant";
  webPort = 8123;
in
  {spaghetti, ...}: {
    networking.firewall.allowedTCPPorts = [webPort];

    virtualisation.oci-containers.containers = {
      home-assistant = {
        hostname = "${hostName}-serv";
        autoStart = true;
        image = "ghcr.io/home-assistant/home-assistant:latest";
        ports = ["8123:8123/tcp"];
        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/home/${spaghetti.user}/.containers/${hostName}:/config"
        ];
        environment = {};
        extraOptions = [
          "--device=/dev/ttyUSB0"
          "--network=host"
          "--privileged"
        ];
      };
    };
  }
