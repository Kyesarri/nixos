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
            api = {
              entryPoint = "http";
            };
            entryPoints = {
              http = {
                address = ":8081";
              };
              web = {
                address = ":80";
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
