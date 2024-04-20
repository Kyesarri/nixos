{
  config,
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  environment.systemPackages = [pkgs.flood];

  # define a new group "media", add services / users to this group
  users.groups.media = {
    name = "media";
    members = ["transmission" "radarr" "sonarr" "prowlarr" "${spaghetti.user}"];
  };
  users.groups.prowlarr = {
    name = "prowlarr";
    members = ["${spaghetti.user}" "prowlarr"];
  };
  # add user to groups created by services
  users.users.${spaghetti.user}.extraGroups = ["radarr" "sonarr" "transmission"];

  users.users.radarr = {
    name = "radarr";
    isNormalUser = false;
  };
  users.users.sonarr = {
    name = "sonarr";
    isNormalUser = false;
  };
  users.users.transmission = {
    name = "transmission";
    isNormalUser = false;
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
      settings = {
        rpc-port = 9091;
        rpc-bind-address = "0.0.0.0";
      };
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
}
