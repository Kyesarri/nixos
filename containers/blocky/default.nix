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
      macvlans = ["enp6s0"]; # call the network device to use by name, not by networkd name
      privateNetwork = false;
      config = {pkgs, ...}: {
        services.blocky.enable = true;
        system.stateVersion = "23.11";

        networking = {
          useDHCP = false;
          useNetworkd = true;
          useHostResolvConf = false;
          hostName = "${hostName}";
          firewall.enable = false;
        };

        systemd.network = {
          enable = true;
          networks = {
            "10-enp6s0" = {
              matchConfig.Name = "11-enp6s0";
              address = ["192.168.87.1/24"];
              # networkConfig.DHCP = "yes";
              dhcpV4Config.ClientIdentifier = "mac";
            };
          };
        };
      };
    };
  }
