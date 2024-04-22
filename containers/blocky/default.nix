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
      macvlans = ["enp2s0"];
      privateNetwork = false;
      hostBridge = "br0";
      config = {pkgs, ...}: {
        services.blocky.enable = true;
        system.stateVersion = "23.11";
        networking = {
          useDHCP = false;
          useNetworkd = true;
          useHostResolvConf = false;
          hostName = "${hostName}";
          firewall = {
            enable = false;
            allowedTCPPorts = [webPort];
          };
        };
        systemd.network = {
          enable = true;
          networks = {
            "40-mv-enp2s0" = {
              matchConfig.Name = "mv-enp2s0";
              address = [
                "192.168.1.3/24"
              ];
              networkConfig.DHCP = "yes";
              dhcpV4Config.ClientIdentifier = "mac";
            };
          };
        };
      };
    };
  }
