{
  config,
  pkgs,
  lib,
  ...
}: {
  networking = {
    hostName = "nix-erying";
    networkmanager.enable = false;
    useNetworkd = true;
    usePredictableInterfaceNames = lib.mkDefault true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes connection issues with tailscale
      allowedTCPPorts = [22];
      allowedUDPPorts = [53 config.services.tailscale.port];
    };
  };

  systemd.network = {
    enable = true;
    wait-online.enable = lib.mkForce false;

    netdevs = {
      "10-br0-enp1s0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };
    };

    "10-lan-bridge" = {
      matchConfig.Name = "br0";
      linkConfig.RequiredForOnline = "routable";
      networkConfig = {
        Address = ["192.168.87.30/24"];
        Gateway = "192.168.87.251";
        DNS = "1.1.1.1";
        IPv6AcceptRA = true;
      };
    };

    "20-eno1" = {
      matchConfig.Name = "enp1s0";
      networkConfig.Bridge = "br0";
      linkConfig.RequiredForOnline = "enslaved";
    };

    /*
    networks."10-enp1s0:" = {
      matchConfig.Name = "enp1s0"; # 2.5g built-in
      address = ["192.168.87.30/24"];
      routes = [{routeConfig.Gateway = "192.168.87.251";}];
      linkConfig.RequiredForOnline = "routable";
    };
    */
    /*
    networks."20-xxx:" = {
      matchConfig.Name = "xxx:"; # TODO - m.2 ethernet
      address = ["192.168.xx.xx/24"];
      routes = [{routeConfig.Gateway = "192.168.xx.xx";}];
      linkConfig.RequiredForOnline = "routable";
    };
    */
  };
}
