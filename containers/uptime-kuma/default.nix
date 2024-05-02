let
  hostName = "uptime-kuma";
  webPort = 3001;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    containers.${hostName} = {
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      #
      config = {
        config,
        pkgs,
        ...
      }: {
        #
        boot.isContainer = true;
        system.stateVersion = "23.11";
        services.uptime-kuma.enable = true;

        networking = {
          hostName = "${hostName}";
          defaultGateway.address = "192.168.87.251";
          nameservers = ["1.1.1.1"];
          # firewall.interfaces."eth0".allowedTCPPorts = [webPort];
          firewall.enable = false;
          useHostResolvConf = lib.mkForce false;
          interfaces."eth0" = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.87.2";
                prefixLength = 24;
              }
            ];
            ipv4.routes = [
              {
                address = "192.168.87.0";
                prefixLength = 24;
                via = "192.168.87.1";
              }
            ];
          };
        };
      };
    };
  }
