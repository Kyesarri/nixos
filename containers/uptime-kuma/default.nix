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
      config = {
        config,
        pkgs,
        ...
      }: {
        boot.isContainer = true;
        system.stateVersion = "23.11";
        services.uptime-kuma.enable = true;
        networking.defaultGateway.address = "192.168.87.251";
        networking.nameservers = ["1.1.1.1"];
        networking.firewall.interfaces."eth0".allowedTCPPorts = [webPort];
        networking.interfaces."eth0".useDHCP = false;
        networking.interfaces."eth0".ipv4.addresses = [
          {
            address = "192.168.87.2";
            prefixLength = 24;
          }
        ];
        networking.hostName = "${hostName}";
        networking.firewall.enable = false;
        # networking.firewall.allowedTCPPorts = [webPort 80 22];
        networking.useHostResolvConf = lib.mkForce false;
      };
    };
  }
