{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./authelia
    # ./blocky
    # ./codeproject
    ./frigate
    ./home-assistant
    # ./nextcloud
    ./nginx-proxy-manager
    ./plex
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools
  ];

  systemd.network = {
    enable = true;
    netdevs = {
      "30-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };
    networks = {
      "10-lan" = {
        matchConfig.Name = "enp6s0"; # 2.5g m.2
        address = ["192.168.87.9/24"];
        routes = [{routeConfig.Gateway = "192.168.87.251";}];
        linkConfig.RequiredForOnline = "routable";
      };
      /*
        networkConfig = {
          Address = "192.168.87.99/24";
          Gateway = "192.168.87.251";
          DNS = ["1.1.1.1"];
        };
      };
      */
      "20-eno1" = {
        matchConfig.Name = "eno1"; # integrated 1g
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
      /*
      "10-wan" = {
        matchConfig.Name = "eno1";
        address = ["192.168.87.9/24"];
        routes = [{routeConfig.Gateway = "192.168.87.251";}];
        linkConfig.RequiredForOnline = "routable";
      };
      */
    };
  };
}
/*
networking = {
  # useNetworkd = true;
  useDHCP = false;
  usePredictableInterfaceNames = true; # not sure if this changed anything
  defaultGateway = "192.168.87.251";
  nameservers = ["192.168.87.251"];

  bridges.br0.interfaces = ["eno1"]; # serv bridge

  interfaces = {
    "br0" = {
      useDHCP = false;

      ipv4.addresses = [
        {
          address = "192.168.87.9";
          prefixLength = 24;
        }
      ];
    };

    "enp6s0" = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.87.99"; # testing realtek m.2 e 2.5g card in serv
          prefixLength = 24; # may bring this interface or onboard in as a vlan for cameras and iot
        }
      ];
    };
  };
};
*/

