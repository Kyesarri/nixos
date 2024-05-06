{
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "erying";
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22];
      # allowedUDPPorts = [53 config.services.tailscale.port];
    };
  };

  systemd.network.enable = true;

  boot.initrd.systemd.network = {
    enable = true;
    networks."10-lan" = {
      address = ["192.168.87.1/24"];
      gateway = ["192.168.87.251"];
      matchConfig.Name = ["enp3s0"];
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
