let
  hostName = "arr";
  webPort = 80;
  transmissionPort = 9091;
  floodPort = 3000;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [webPort transmissionPort floodPort];

    containers.${hostName} = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.87.9/24";
      localAddress = "192.168.87.11/24";
      #hostBridge = "br0";
      #localAddress = "192.168.87.11/24";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services = {
          resolved.enable = true;
          transmission = {
            enable = true;
            # webHome = pkgs.flood;
            performanceNetParameters = true;
            openFirewall = true;
            openRPCPort = true;
            openPeerPorts = true;
          };
        };

        networking = {
          defaultGateway = "192.168.87.251";
          interfaces."eno1".ipv4.routes = [
            {
              address = "192.168.87.0";
              prefixLength = 24;
              via = "192.168.87.9";
            }
          ];
          useHostResolvConf = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort floodPort transmissionPort];
          };
        };
        environment.systemPackages = with pkgs; [flood kitty];
      };
    };
  }
