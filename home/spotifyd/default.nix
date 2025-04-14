{
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

  networking.firewall = {
    allowedTCPPorts = [5353];
    allowedUDPPorts = [5353];
  };
}
