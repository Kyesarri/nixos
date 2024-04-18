let
  hostName = "arr";
  webPort = 80;
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
      localAddress = "192.168.87.11/24";
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
            webHome = "pkgs.flood";
            performanceNetParameters = true;
            openFirewall = true;
          };
        };

        networking = {
          defaultGateway = "192.168.87.251";
          useHostResolvConf = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
        };
        environment.systemPackages = with pkgs; [flood];
      };
    };
  }
