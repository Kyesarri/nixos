{config, ...}: {
  ## bridge

  # networking.nat = {
  #  enable = true;
  #  internalInterfaces = ["ve-+"];
  #  externalInterface = "enp1s0"; # moving to m.2 ethernet "soon"
  #  # Lazy IPv6 connectivity for the container # do i want ipv6? :)
  #  enableIPv6 = false;
  # };

  networking = {
    bridges.br0.interfaces = ["enp1s0"]; # serv interface

    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.87.5";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.87.251";
    nameservers = ["192.168.87.1"];
  };

  imports = [
    ./nextcloud
  ];
}
