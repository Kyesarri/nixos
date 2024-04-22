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
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      localAddress = "192.168.87.1/24";

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

        # environment.systemPackages = with pkgs; [ffmpeg_5-full lshw];

        services.blocky.enable = true;
      };
    };
  }
