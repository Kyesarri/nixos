let
  hostName = "home-assistant";
  webPort = 8123;
in
  {
    spaghetti,
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [webPort];
    system.activationScripts.makeHome-AssistantDir =
      lib.stringAfter ["var"]
      ''mkdir -p /home/${spaghetti.user}/.containers/${hostName}/data /home/${spaghetti.user}/.containers/${hostName}/letsencrypt'';

    virtualisation.oci-containers.containers = {
      home-assistant = {
        hostname = "${hostName}-serv";
        autoStart = true;
        image = "ghcr.io/home-assistant/home-assistant:stable";
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
