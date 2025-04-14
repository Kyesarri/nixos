{
  lib,
  pkgs,
  config,
  secrets,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {pkgs, ...}: {
    services.spotifyd = {
      enable = true;
      settings.global = {
        username = "${secrets.email.alternate}";
        password_cmd = "${secrets.password.spotify}";
        backend = "pulseaudio";
        no_audio_cache = true;
        bitrate = 320;
        device_name = "spotify-${config.networking.hostName}";
        device_type = "computer";
        use_mpris = false;
      };
    };
    home.packages = [pkgs.spotify-player];
  };

  # https://github.com/camillemndn/infra/tree/4c87eecbc7870b15d59d08c71092ab4aaea29040/profiles/spotifyd
  /*
  systemd.services.spotifyd.serviceConfig = {
    DynamicUser = lib.mkForce false;
    SupplementaryGroups = lib.mkForce [
      "audio"
      "pipewire"
    ];
  };
  */
  networking.firewall = {
    allowedTCPPorts = [5353];
    allowedUDPPorts = [5353];
  };
}
