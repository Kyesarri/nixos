let
  chrony = 123;
  tailscale = 41641;
  ssh = 22;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking = {
      hostName = "nix-serv";
      hostId = "bed5b7cd"; # required for lvm disks
      networkmanager.enable = false;
      useNetworkd = true;
      usePredictableInterfaceNames = mkDefault true;

      firewall = {
        enable = true;
        checkReversePath = "loose"; # fixes connection issues with tailscale
        allowedTCPPorts = [ssh chrony];
        allowedUDPPorts = [tailscale chrony];
      };
    };

    systemd.network = {
      enable = true;
      wait-online.enable = lib.mkForce false;

      netdevs."30-br0-eno1" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };

      networks."10-enp6s0" = {
        matchConfig.Name = "enp6s0"; # 2.5g m.2
        address = ["192.168.87.9/24"];
        routes = [{routeConfig.Gateway = "192.168.87.251";}];
        linkConfig.RequiredForOnline = "routable";
      };

      networks."20-eno1" = {
        matchConfig.Name = "eno1"; # integrated 1g
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };
    };
  }
