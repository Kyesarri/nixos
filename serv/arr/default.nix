{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [./flood.nix];

  users.users.media = {
    name = "media";
    group = "media";
    isNormalUser = false;
    uid = 880;
  };

  # define a new group "media", add services / users to this group
  users.groups.media = {
    name = "media";
    members = ["media" "prowlarr" "${spaghetti.user}"];
  };

  # add user to groups created by services
  # users.users.${spaghetti.user}.extraGroups = ["radarr" "sonarr" "transmission" "readarr"];

  services = {
    resolved.enable = true;
    transmission = {
      enable = true;
      user = "media";
      performanceNetParameters = true;
      openFirewall = true;
      openRPCPort = true;
      openPeerPorts = true;
      settings = {
        ratio-limit = 3;
        ratio-limit-enabled = true;
        idle-seeding-limit-enabled = true;
        trash-original-torrent-files = true;
        incomplete-dir-enabled = false;
        dht-enabled = true;
        download-dir = "/hddb/torrents/";
        download-queue-enabled = false;
        peer-port = 51413;
        rpc-authentication-required = false;
        rpc-host-whitelist-enabled = false;
        rpc-whitelist-enabled = false;
        rpc-port = 9091;
        rpc-bind-address = "${toString secrets.ip.serv-1}";
      };
    };
    radarr = {
      enable = true;
      openFirewall = true;
      user = "media";
    };
    sonarr = {
      enable = true;
      openFirewall = true;
      user = "media";
    };
    prowlarr = {
      enable = true;
      openFirewall = true;
      user = "media";
    };
    readarr = {
      enable = true;
      openFirewall = true;
      user = "media";
    };
  };
}
