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
      usePredictableInterfaceNames = lib.mkDefault true;
      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = "enp6s0";
        # Lazy IPv6 connectivity for the container
        enableIPv6 = true;
      };
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

      # create a bridge, named br0
      netdevs."br0" = {
        netdevConfig = {
          Name = "br0";
          Kind = "bridge";
        };
      };

      # bridge adaptor
      networks."20-eno1" = {
        matchConfig.Name = "eno1"; # integrated 1g
        networkConfig.Bridge = "br0";
        linkConfig.RequiredForOnline = "enslaved";
      };

      networks."10-enp6s0" = {
        matchConfig.Name = "enp6s0"; # 2.5g m.2
        address = ["192.168.87.9/24"];
        routes = [{routeConfig.Gateway = "192.168.87.251";}];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  }
