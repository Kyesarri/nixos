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
    containers.${hostName} = {
      autoStart = true;
      privateNetwork = true;
      localAddress = "192.168.87.2/24";
      hostAddress = "192.168.87.1";
      # hostBridge = "br0";
      # macvlans = ["enp1s0"];
      enableTun = true;
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
        networking.firewall.allowedTCPPorts = [webPort];
        networking.useHostResolvConf = lib.mkForce false;
        networking.useNetworkd = true;
      };
    };
  }
