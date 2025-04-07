{
  secrets,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-eliteone";
    hostId = "621eebd9";
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
      address = ["${toString secrets.ip.eliteone}/24"];
      gateway = ["${toString secrets.ip.gateway}"];
      matchConfig.Name = ["eno1"];
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        IPv6PrivacyExtensions = "yes";
        MulticastDNS = true;
      };
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
        address = ["${toString secrets.ip.eliteone}/24"];
        gateway = ["${toString secrets.ip.gateway}"];
        matchConfig.Name = "lan-self";
        linkConfig.RequiredForOnline = "routable";
        networkConfig = {
          IPv6PrivacyExtensions = "yes";
          MulticastDNS = true;
        };
      };
    };
  };
}
