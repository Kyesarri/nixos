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
      # create network bridge
      netdevs = {
        "30-br0" = {
          netdevConfig = {
            Kind = "bridge";
            Name = "br0";
          };
        };
      };

      networks = {
        # configure 2.5 as our main interface on the network
        "10-enp6s0" = {
          matchConfig.Name = "enp6s0"; # 2.5g m.2
          address = ["192.168.87.9/24"];
          routes = [{routeConfig.Gateway = "192.168.87.251";}];
          linkConfig.RequiredForOnline = "routable";
        };

        # use onboard 1g as our bridge
        "20-eno1" = {
          matchConfig.Name = "eno1"; # integrated 1g
          networkConfig.Bridge = "br0";
          linkConfig.RequiredForOnline = "enslaved";
        };
      };
    };
  }
