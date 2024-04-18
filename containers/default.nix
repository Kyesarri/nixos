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
      defaultNetwork.settings = {};
    };
  };

  environment.systemPackages = with pkgs; [podman intel-gpu-tools];

  networking = {
    usePredictableInterfaceNames = true;
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.251"];
    nat = {
      enable = true;
      internalInterfaces = ["ve-+"];
      externalInterface = "eno1";
    };

    interfaces = {
      "eno1" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.87.9"; # testing realtek m.2 e 2.5g card in serv
            prefixLength = 24;
          }
        ];
      };
      "enp6s0" = {
        useDHCP = false;
        ipv4.addresses = [
          {
            address = "192.168.87.1"; # testing realtek m.2 e 2.5g card in serv
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
/*
"br0" = {
  useDHCP = true; # bridged devices use dhcp by default
  ipv4.addresses = [
    {
      address = "192.168.87.9"; # bridge ip?
      prefixLength = 24;
    }
  ];
};
*/

