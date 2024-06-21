{
  secrets,
  lib,
  ...
}: let
  chrony = 123;
  tailscale = 41641;
  ssh = 22;
in {
  networking = {
    hostName = "nix-serv";
    hostId = "bed5b7cd"; # required for lvm disks
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;

    nat = {
      enable = true;
      internalInterfaces = ["veth+"];
      externalInterface = "enp3s0";
    };

    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [ssh chrony 22];
      allowedUDPPorts = [tailscale chrony 53];
    };
  };

  systemd.network.networks."50-eno1" = {
    matchConfig.Name = "eno1"; # integrated 1g, primary connection
    address = ["${toString secrets.ip.serv-1}/24"];
    routes = [{routeConfig.Gateway = "${toString secrets.ip.gateway}";}];
    linkConfig.RequiredForOnline = "routable";
  };

  # Config for the physical interface itself with DHCP enabled and associated to a MACVLAN.
  systemd.network.networks."40-enp" = {
    matchConfig.Name = "enp3s0";
    networkConfig.DHCP = "yes";
    dhcpConfig.UseDNS = "no";
    networkConfig.MACVLAN = "mv-enp-host";
    linkConfig.RequiredForOnline = "no";
    address = lib.mkForce [];
    addresses = lib.mkForce [];
  };

  # The host-side sub-interface of the MACVLAN. This means that the host is reachable
  # at ip, both on the physical interface and from the container.
  systemd.network.networks."20-mv-enp-host" = {
    matchConfig.Name = "mv-enp-host";
    networkConfig.IPForward = "yes";
    dhcpV4Config.ClientIdentifier = "mac";
    address = lib.mkForce ["${toString secrets.ip.serv-2}/24"];
    routes = [{routeConfig.Gateway = "${toString secrets.ip.gateway}";}];
  };

  systemd.network.netdevs."20-mv-enp-host" = {
    netdevConfig = {
      Name = "mv-enp-host";
      Kind = "macvlan";
    };
    extraConfig = ''
      [MACVLAN]
      Mode=bridge
    '';
  };
}
