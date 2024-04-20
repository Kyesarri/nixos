{
  config,
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.extraGroups = "media";
  users.users.radarr = {
    name = "radarr";
    isNormalUser = false;
    group = "media";
  };
  users.users.sonarr = {
    name = "sonarr";
    isNormalUser = false;
    group = "media";
  };
  users.users.transmission = {
    name = "transmission";
    isNormalUser = false;
    group = "media";
  };
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
  environment.systemPackages = [pkgs.flood];
}
