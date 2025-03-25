{
  secrets,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-erying";
    hostId = "9f7ea1ec";
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault false;
    resolvconf.dnsExtensionMechanism = false;

    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22 123 80 443 7125 8080 8081 3493];
      allowedUDPPorts = [41641 123];
    };
  };

  services.resolved.dnssec = "false";

  boot.initrd.systemd.network = {
    enable = true;
    networks."10-lan" = {
      address = ["${toString secrets.ip.erying}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = ["eth0"];
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
      linkConfig.RequiredForOnline = "routable";
    };
  };

  systemd.network = {
    netdevs = {
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
    #
    networks = {
      "10-lan" = {
        matchConfig.Name = ["eth0"];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "carrier";
        extraConfig = ''
          [Network]
          MACVLAN=lan-self
        '';
      };
      #
      "20-lan-self" = {
        address = ["${toString secrets.ip.erying}/24"];
        gateway = ["${toString secrets.ip.gateway}"];
        matchConfig.Name = "lan-self";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv6PrivacyExtensions = "yes";
          MulticastDNS = true;
        };
      };
      #
      "30-lan2" = {
        matchConfig.Name = ["eth0"];
        networkConfig.LinkLocalAddressing = "no";
        linkConfig.RequiredForOnline = "carrier";
        extraConfig = ''
          [Network]
          MACVLAN=lan2-self
        '';
      };
      #
      "40-lan2-self" = {
        address = ["${toString secrets.ip.lan2.erying}/24"];
        gateway = ["${toString secrets.ip.lan2.gateway}"];
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
