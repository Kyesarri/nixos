{
  spaghetti,
  secrets,
  pkgs,
  ...
}: {
  imports = [./flood.nix];

  # define a new group "media", add services / users to this group
  users.groups.media = {
    name = "media";
    members = ["plex" "transmission" "radarr" "readarr" "sonarr" "prowlarr" "${spaghetti.user}"];
  };

  # issues with sonarr - 11.12.24
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-runtime-wrapped-6.0.36"
    "dotnet-runtime-wrapped-6.0.36"
    "aspnetcore-runtime-wrapped-6.0.36"
    "aspnetcore-runtime-6.0.36"
    "dotnet-sdk-wrapped-6.0.428"
    "dotnet-sdk-6.0.428"
  ];

  # add user to groups created by services
  users.users.${spaghetti.user}.extraGroups = ["radarr" "sonarr" "transmission" "readarr"];

  services = {
    resolved.enable = true;
    transmission = {
      enable = true;
      user = "transmission";
      group = "media";
      package = pkgs.transmission_3;
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
      # group = "media"; # no worky, option does not exist
    };
    readarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
    bazarr = {
      enable = true;
      openFirewall = true;
      group = "media";
    };
  };
}
