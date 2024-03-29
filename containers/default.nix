{config, ...}: {
  ## bridge
  networking = {
    bridges.br0.interfaces = ["enp1s0"]; # serv interface
    useDHCP = false; # for host?
    interfaces."br0".useDHCP = true; # guessing this is other vlan use dhcp?
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.87.9"; # host ip?
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.1"];
  };
}
