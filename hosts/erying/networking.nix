# heaps going on here, some fairly straightforward like host-name
# others like hostid (for zfs) are not so intuitive
# macvlan config is further down in this file
{
  secrets,
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-erying";
    hostId = "9f7ea1ec";
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    resolvconf.dnsExtensionMechanism = false;

    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22 123];
      allowedUDPPorts = [config.services.tailscale.port 123];
    };
  };

  services.resolved.dnssec = "false";

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = true;
    "net.ipv6.conf.all.forwarding" = true;
  };

  boot.initrd.systemd.network = {
    enable = true;
    networks."10-lan" = {
      address = ["${toString secrets.ip.erying}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = ["enp3s0"];
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  systemd.network.netdevs."10-lan-self" = {
    netdevConfig = {
      Name = "lan-self";
      Kind = "macvlan";
    };
    extraConfig = ''
      [MACVLAN]
      Mode=bridge
    '';
  };

  systemd.network.networks = {
    "10-lan" = {
      matchConfig.Name = ["enp3s0"];
      networkConfig.LinkLocalAddressing = "no";
      linkConfig.RequiredForOnline = "carrier";
      extraConfig = ''
        [Network]
        MACVLAN=lan-self
      '';
    };
    "20-lan-self" = {
      address = ["${toString secrets.ip.erying}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = "lan-self";
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };
}
