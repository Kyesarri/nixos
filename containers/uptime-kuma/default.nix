let
  hostName = "uptime-kuma";
  webPort = 4000;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [webPort];

    containers.${hostName} = {
      autoStart = true;
      privateNetwork = true;
      localAddress = "192.168.87.2/24";
      # hostBridge = "br0";
      macvlans = ["10-lan"];
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.uptime-kuma.enable = true;
        services.uptime-kuma.settings = {
          PORT = "4000";
        };
        networking.hostName = "${hostName}";
        networking.useHostResolvConf = lib.mkForce false;
        networking.useNetworkd = true;
      };
    };
  }
