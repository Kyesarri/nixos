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
      enable = false;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22];
      allowedUDPPorts = [config.services.tailscale.port];
    };

    # configure the bridge interface
    bridges."br0".interfaces = ["enp1s0"];

    # give the bridge an ip with dhcp
    useDHCP = false;
    interfaces."br0".useDHCP = true;

    # set a static ip for the bridge itself
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
