{
  config,
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.extraGroups = "media" "radarr" "sonarr" "transmission";
  users.users.radarr = {
    name = "radarr";
    isNormalUser = false;
    extraGroups = "media";
  };
  users.users.sonarr = {
    name = "sonarr";
    isNormalUser = false;
    extraGroups = "media";
  };
  users.users.transmission = {
    name = "transmission";
    isNormalUser = false;
    extraGroups = "media";
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
