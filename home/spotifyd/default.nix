{
  config,
  secrets,
  ...
}: {
  services.spotifyd = {
    enable = true;
    settings.global = {
      username = "${secrets.email.alternate}";
      password_cmd = "${secrets.password.spotify}";
      backend = "pulseaudio";
      device_name = "spotify-${config.networking.hostName}";
      device_type = "computer";
      use_mpris = false;
    };
  };
  networking.firewall = {
    allowedTCPPorts = [5353];
    allowedUDPPorts = [5353];
  };
}
