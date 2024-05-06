{
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-erying";
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

  systemd.network.netdevs."br0" = {
    netdevConfig = {
      Name = "br0";
      Kind = "bridge";
    };
  };

  systemd.network.networks."10-lan" = {
    matchConfig.Name = ["enp3s0"];
    networkConfig = {
      Bridge = "br0";
    };
  };

  systemd.network.networks."19-podman" = {
    matchConfig.Name = "veth*";
    linkConfig = {
      Unmanaged = true;
    };
  };

  systemd.network.networks."10-lan-bridge" = {
    matchConfig.Name = "br0";
    networkConfig = {
      Address = ["192.168.87.1/24"];
      Gateway = "192.168.87.251";
      DNS = ["192.168.87.251"];
      IPv6AcceptRA = true;
    };
    linkConfig.RequiredForOnline = "routable";
  };
}
