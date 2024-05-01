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
      hostBridge = "br0";
      config = {
        config,
        pkgs,
        ...
      }: {
        boot.isContainer = true;
        system.stateVersion = "23.11";
        services.uptime-kuma.enable = true;
        services.uptime-kuma.settings = {PORT = "4000";};
        networking.interfaces.eth0.useDHCP = true;
        networking.hostName = "${hostName}";
        networking.firewall.allowedTCPPorts = [webPort 80 22];
        networking.useHostResolvConf = lib.mkForce false;
      };
    };
  }
