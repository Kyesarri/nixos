{
  secrets,
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
      checkReversePath = "loose";
      allowedTCPPorts = [22 123 443];
      allowedUDPPorts = [443 123 41641];
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
      # builtin lan / main interface
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

      # m.2 a+e ethernet / lan2
      "30-lan2" = {
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

  systemd.network = {
    netdevs = {
      # main lan
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
      # lan2
      "30-lan2-self" = {
        netdevConfig = {
          Name = "lan2-self";
          Kind = "macvlan";
        };
        extraConfig = ''
          [MACVLAN]
          Mode=bridge
        '';
      };
    };

    networks = {
      # main lan macvlan for containers
      "10-lan" = {
        matchConfig.Name = ["eno1"];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "carrier";
        extraConfig = ''
          [Network]
          MACVLAN=lan-self
        '';
      };
      # main lan
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
      # lan2 macvlan
      "30-lan2" = {
        matchConfig.Name = ["enp4s0"];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "carrier";
        extraConfig = ''
          [Network]
          MACVLAN=lan2-self
        '';
      };
      # lan2
      "40-lan2-self" = {
        address = ["${toString secrets.ip.serv-2}/24"];
        gateway = ["${toString secrets.ip.gateway}"];
        matchConfig.Name = "lan2-self";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv6PrivacyExtensions = "yes";
          MulticastDNS = true;
        };
      };
    };
  };
}
