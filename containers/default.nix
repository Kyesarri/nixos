/*
let
cont = {
  nginx = {
  ip = "192.168.87.1";
  webPort = 81;
  };
};
in
*/
{
  config,
  pkgs,
  ...
}: {
  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [podman podman-tui intel-gpu-tools];

  networking = {
    useNetworkd = true;
    useDHCP = false;
    usePredictableInterfaceNames = true; # not sure if this changed anything
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.251"];
    /*
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "br0";
    };
    */

    bridges.br0.interfaces = ["eno1"]; # serv bridge

    interfaces = {
      "br0" = {
        useDHCP = true; # bridged devices use dhcp by default
        ipv4.addresses = [
          {
            address = "192.168.87.9"; # bridge ip
            prefixLength = 24;
          }
        ];
      };
      /*
      ipv4.routes = [
        {
          address = "192.168.87.0";
          prefixLength = 24;
          via = "192.168.87.9";
        }
      ];
      */
      "enp6s0" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.87.99"; # testing realtek m.2 e 2.5g card in serv
            prefixLength = 24;
          }
        ];
      };
    };
  };
}
/*
  systemd.network.links = {
  "10-wan" = {
    matchConfig.MACAddress = "68:27:19:a5:79:51";
    linkConfig.Name = "wan0";
  };
  "10-lan" = {
    matchConfig.MACAddress = "68:27:19:a5:79:52";
    linkConfig.Name = "lan0";
  };
};
*/
/**/

