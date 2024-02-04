{config, ...}: {
  ## bridge
  networking = {
    bridges.br0.interfaces = ["enp1s0"]; # serv interface
    useDHCP = false;
    interfaces."br0".useDHCP = false;
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.87.9";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.1"];
  };
}
