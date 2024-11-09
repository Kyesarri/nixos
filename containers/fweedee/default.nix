{secrets, ...}: {
  containers.fweedee = {
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

        klipper = {
          enable = true;
          configFile = ./printer.cfg;
        };
        /*
        mainsail = {
          enable = true;
        };
        */
        fluidd = {
          enable = true;
        };
        /*
        traefik = {
          enable = true;
          staticConfigOptions = {
            log.level = "DEBUG";

            api = {};
            entryPoints = {
              http = {
                address = ":80";
              };
              https = {
                address = ":443";
              };
              web = {
                address = ":8080";
              };
            };
          };
        };
        */
      };

      networking = {
        useHostResolvConf = lib.mkForce false;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443 8080];
        };
      };
    };
  };
}
