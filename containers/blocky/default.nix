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
      # hostAddress = "192.168.87.9";
      hostBridge = "br0";
      localAddress = "192.168.87.2/24";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";

        networking = {
          hostName = "${hostName}";
          domain = "home.lan";
          nameservers = ["192.168.87.251"];
          defaultGateway = "192.168.87.251";
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
          # workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        # environment.systemPackages = with pkgs; [ffmpeg_5-full lshw];

        services.blocky.enable = true;
      };
    };
  }
