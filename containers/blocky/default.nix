let
  hostName = "blocky";
  webPort = 80;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    containers.${hostName} = {
      services.blocky.enable = true;

      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";

        networking = {
          hostName = "${hostName}";
          # domain = "home.lan";
          # nameservers = ["192.168.87.251"];
          # defaultGateway = "192.168.87.251";
          useHostResolvConf = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
        };
      };
    };
  }
