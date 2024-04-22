let
  # toss some ports here
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

    systemd.network = {
      enable = true;
      wait-online.enable = lib.mkForce false;

      netdevs.lan = {
        enable = lib.mkDefault true;
        netdevConfig.Kind = "macvlan";
        netdevConfig.Name = "lan";
        macvlanConfig.Mode = lib.mkDefault "bridge";
      };

      networks.lan = {
        networkConfig.DNSSEC = lib.mkDefault false;
        matchConfig.Name = lib.mkDefault "lan";
        linkConfig.ARP = true;
        networkConfig.IPv6AcceptRA = "no";
        networkConfig.LinkLocalAddressing = "no";
      };

      networks.local-eth = {
        macvlan = ["lan"];
        matchConfig.Name = "eno1";
        linkConfig.ARP = false;
        networkConfig.IPv6AcceptRA = "no";
        networkConfig.LinkLocalAddressing = "no";
      };

      networks."10-enp6s0" = {
        matchConfig.Name = "enp6s0"; # 2.5g m.2
        address = ["192.168.87.9/24"];
        routes = [{routeConfig.Gateway = "192.168.87.251";}];
        linkConfig.RequiredForOnline = "routable";
      };
    };
  }
/*
# use onboard 1g as our macvlan
"20-eno1" = {
  matchConfig.Name = "eno1"; # integrated 1g
  networkConfig.Bridge = "br0";
  linkConfig.RequiredForOnline = "enslaved";
};
*/

