{
  secrets,
  config,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-serv";
    hostId = "bed5b7cd"; # required for lvm disks
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    timeServers = ["ntp.nml.csiro.au" "ntp.ise.canberra.edu.au"];

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
    networks = {
      "10-lan" = {
        address = ["${toString secrets.ip.serv-1}/24"];
        gateway = ["${toString secrets.ip.gateway}"];
        matchConfig.Name = ["eno1"];
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv6PrivacyExtensions = "yes";
          MulticastDNS = true;
        };
      };
      # wait for this to break the internet
      "30-vlan" = {
        address = ["${toString secrets.ip.serv-2}/24"];
        gateway = ["${toString secrets.ip.gateway}"];
        matchConfig.Name = ["enp4s0"];
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv6PrivacyExtensions = "yes";
          MulticastDNS = true;
        };
      };
    };
  };

  systemd.network.netdevs = {
    "10-lan-self" = {
      netdevConfig = {
        Name = "lan-self";
        Kind = "macvlan";
      };
      extraConfig = ''
        [MACVLAN]
        Mode=bridge
      '';
    };

    "30-vlan-self" = {
      netdevConfig = {
        Name = "vlan-self";
        Kind = "macvlan";
      };
      extraConfig = ''
        [MACVLAN]
        Mode=bridge
      '';
    };
  };

  systemd.network.networks = {
    "10-lan" = {
      matchConfig.Name = ["eno1"];
      networkConfig.LinkLocalAddressing = "no";
      linkConfig.RequiredForOnline = "carrier";
      extraConfig = ''
        [Network]
        MACVLAN=lan-self
      '';
    };
    "30-vlan" = {
      matchConfig.Name = ["enp4s0"];
      networkConfig.LinkLocalAddressing = "no";
      linkConfig.RequiredForOnline = "carrier";
      extraConfig = ''
        [Network]
        MACVLAN=vlan-self
      '';
    };
    "20-lan-self" = {
      address = ["${toString secrets.ip.serv-1}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = "lan-self";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
    };
    "30-vlan-self" = {
      address = ["${toString secrets.ip.serv-2}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = "vlan-self";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
    };
  };
}
