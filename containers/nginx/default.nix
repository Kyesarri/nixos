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
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      localAddress = "192.168.87.2/24"; # container ip

      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";

        networking = {
          hostName = "${hostName}";
          domain = "home.lan";
          nameservers = ["1.1.1.1"];
          defaultGateway = "192.168.87.251";
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
          # workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        # environment.systemPackages = with pkgs; [ffmpeg_5-full lshw];

        services.resolved.enable = true;
        services.nginx = {
          enable = true;
          recommendedGzipSettings = true;
          recommendedOptimisation = true;
          recommendedProxySettings = true;
          recommendedTlsSettings = true;
          /*
            virtualHosts."whatever.net" = {
            default = true;
            enableACME = false;
            addSSL = true;
            locations."/".proxyPass = "http://127.0.0.1:9955/";
          };
          */
        };
      };
    };
  }
