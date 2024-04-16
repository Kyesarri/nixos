{config, ...}: {
  ## bridge
  networking = {
    bridges.br0.interfaces = ["eno1"]; # serv interface
    useDHCP = false; # for host?
    interfaces."br0".useDHCP = true; # bridged devices use dhcp by default
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.87.9"; # host ip
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.87.251";
    nameservers = ["1.1.1.1"];
  };
}
