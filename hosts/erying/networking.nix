{
  config,
  pkgs,
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
      allowedUDPPorts = [53 config.services.tailscale.port];
    };
  };

  systemd.network = {
    enable = true;
    wait-online.enable = lib.mkForce false;

    netdevs = {
      # Create the bridge interface
      "10-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };

    networks."10-bridge" = {
      matchConfig.Name = "br0";
      networkConfig = {
        Address = ["192.168.87.1/24"];
        Gateway = "192.168.87.251";
        DNS = ["192.168.87.251"];
        IPv6AcceptRA = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
