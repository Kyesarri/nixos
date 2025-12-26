{
  spaghetti,
  secrets,
  pkgs,
  lib,
  ...
}: {
  imports = [./flood.nix];

  # define a new group "media", add services / users to this group
  users.groups.media = {
    name = "media";
    gid = 989;
    members = ["plex" "transmission" "bazarr" "radarr" "readarr" "sonarr" "prowlarr" "lidarr" "${spaghetti.user}"];
  };

  # add user to groups created by services
  users.users.${spaghetti.user}.extraGroups = ["radarr" "sonarr" "transmission" "readarr"];

  services = {
    resolved.enable = true;
    transmission = {
      enable = true;
      user = "transmission";
      group = "media";
      package = pkgs.transmission_4;
      performanceNetParameters = true;
      openFirewall = true;
      openRPCPort = true;
      openPeerPorts = true;
      settings = {
        ratio-limit = 3; # pls seed
        ratio-limit-enabled = true;
        idle-seeding-limit-enabled = false;
        trash-original-torrent-files = true;
        incomplete-dir-enabled = true;
        incomplete-dir = "/storage/incomplete/";
        dht-enabled = true;
        download-dir = "/storage/torrents/";
        download-queue-enabled = false;
        peer-port = 51413;
        rpc-authentication-required = false;
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
        rpc-bind-address = "${toString secrets.ip.serv-1}";
        utp-enabled = true; # test
      };
    };
    radarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    sonarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
    };
    readarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    bazarr = {
      enable = true;
      openFirewall = true;
      user = "bazarr";
      group = "media";
    };
    lidarr = {
      enable = true;
      openFirewall = true;
      user = "lidarr";
      group = "media";
    };
  };
}
