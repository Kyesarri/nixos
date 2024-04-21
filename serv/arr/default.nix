{
  config,
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  imports = [./flood.nix];

  # define a new group "media", add services / users to this group
  users.groups.media = {
    name = "media";
    members = ["transmission" "radarr" "sonarr" "prowlarr" "${spaghetti.user}"];
  };

  # add user to groups created by services
  users.users.${spaghetti.user}.extraGroups = ["radarr" "sonarr" "transmission"];

  services = {
    resolved.enable = true;
    transmission = {
      enable = true;
      user = "transmission";
      performanceNetParameters = true;
      openFirewall = true;
      openRPCPort = true;
      openPeerPorts = true;
      settings = {
        dht-enabled = true;
        download-dir = "/hddb/torrents/";
        download-queue-enabled = false;
        peer-port = 51413;
        rpc-authentication-required = false;
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
        rpc-bind-address = "192.168.87.9";
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
