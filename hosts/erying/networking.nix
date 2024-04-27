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

    networks."10-enp1s0:" = {
      matchConfig.Name = "enp1s0"; # 2.5g built-in
      address = ["192.168.87.30/24"];
      routes = [{routeConfig.Gateway = "192.168.87.251";}];
      linkConfig.RequiredForOnline = "routable";
    };
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
