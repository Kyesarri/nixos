{
  config,
  pkgs,
  lib,
  ...
}: {
  networking.firewall.allowedTCPPorts = [3000];

  services = {
    resolved.enable = true;
    transmission = {
      enable = true;
      user = "transmission";
      webHome = pkgs.flood;
      performanceNetParameters = true;
      openFirewall = true;
      openRPCPort = true;
      openPeerPorts = true;
    };
    radarr = {
      enable = true;
      openFirewall = true;
    };
    sonarr = {
      enable = true;
      openFirewall = true;
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [3000];
    };
  };
  environment.systemPackages = [pkgs.flood];
}
