{
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-erying";
    # networkmanager.enable = false;
    # useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;

    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    bridges."br0".interfaces = ["enp1s0"];

    # Get bridge-ip with DHCP
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    # Set bridge-ip static
    interfaces."br0".ipv4.addresses = [
      {
        address = "192.168.87.1";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.87.251";
    nameservers = ["1.1.1.1"];
  };
}
