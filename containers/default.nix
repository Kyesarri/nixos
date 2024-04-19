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
      # defaultNetwork.settings = {};
    };
  };

  environment.systemPackages = with pkgs; [podman intel-gpu-tools];

  networking = {
    usePredictableInterfaceNames = true; # not sure if this changed anything
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.251"];
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "br0";
    };
    bridges.br0.interfaces = ["eno1"]; # serv bridge #1

    interfaces = {
      "br0" = {
        useDHCP = true; # bridged devices use dhcp by default
        ipv4.addresses = [
          {
            address = "192.168.87.9"; # bridge ip?
            prefixLength = 24;
          }
        ];
      };
      /*
      "eno1" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.87.9";
            prefixLength = 24;
          }
        ];
        ipv4.routes = [
          {
            address = "192.168.87.0";
            prefixLength = 24;
            via = "192.168.87.9";
          }
        ];
      };
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

