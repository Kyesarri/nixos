let
  hostName = "nginx";
  webPort = 81;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [webPort];
    containers.${hostName} = {
      #
      autoStart = true;
      extraFlags = ["-U"];
      privateNetwork = true;
      hostBridge = "br0";
      #hostAddress = "192.168.87.9";
      localAddress = "192.168.87.1/24";
      forwardPorts = [
        {
          containerPort = webPort;
          hostPort = webPort;
          protocol = "tcp";
        }
      ];
      #
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        #
        networking = {
          nameservers = ["192.168.87.251"];
          defaultGateway = "192.168.87.251";
          interfaces."eth0".useDHCP = true;
          hostName = "${hostName}";
          useHostResolvConf = lib.mkForce false;
        };

        services = {
          resolved.enable = true;
          nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
          };
        };
      };
    };
  }
