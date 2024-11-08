{secrets, ...}: {
  containers.moonraker = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "${secrets.ip.erying}";
    localAddress = "10.231.136.2";

    config = {lib, ...}: {
      system.stateVersion = "23.11";

      services = {
        resolved.enable = true;

        moonraker = {
          enable = true;
          address = "0.0.0.0";
        };

        traefik = {
          enable = true;
          staticConfigOptions = {
            log.level = "DEBUG";
            api.dashboard = true;
            api.insecure = true;

            entryPoints = {
              http = {
                address = ":80";
              };
              web = {
                address = ":8081";
              };
            };
          };
        };
      };

      networking = {
        useHostResolvConf = lib.mkForce false;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 81 8081 22];
        };
      };
    };
  };
}
