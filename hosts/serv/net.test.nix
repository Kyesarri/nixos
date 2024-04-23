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

      firewall = {
        enable = true;
        checkReversePath = "loose"; # fixes connection issues with tailscale
        allowedTCPPorts = [ssh chrony];
        allowedUDPPorts = [tailscale chrony];
      };
    };

    systemd.network.networks."50-eno1" = {
      matchConfig.Name = "eno1"; # integrated 1g
      address = ["192.168.87.9/24"];
      routes = [{routeConfig.Gateway = "192.168.87.251";}];
      linkConfig.RequiredForOnline = "routable";
    };

    # Config for the physical interface itself with DHCP enabled and associated to a MACVLAN.
    systemd.network.networks."40-enp6s0" = {
      matchConfig.Name = "enp6s0";
      networkConfig.DHCP = "yes";
      dhcpConfig.UseDNS = "no";
      networkConfig.MACVLAN = "mv-enp6s0-host";
      linkConfig.RequiredForOnline = "no";
      address = lib.mkForce [];
      addresses = lib.mkForce [];
    };

    # The host-side sub-interface of the MACVLAN. This means that the host is reachable
    # at `192.168.87.99`, both on the physical interface and from the container.
    systemd.network.networks."20-mv-enp6s0-host" = {
      matchConfig.Name = "mv-enp6s0-host";
      networkConfig.IPForward = "yes";
      dhcpV4Config.ClientIdentifier = "mac";
      address = lib.mkForce [
        "192.168.87.99/24"

        "192.168.87.1/24"
      ];
    };

    systemd.network.netdevs."20-mv-enp6s0-host" = {
      netdevConfig = {
        Name = "mv-enp6s0-host";
        Kind = "macvlan";
      };
      extraConfig = ''
        [MACVLAN]
        Mode=bridge
      '';
    };
  }
