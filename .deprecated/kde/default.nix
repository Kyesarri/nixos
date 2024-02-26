{user, ...}: {
  imports = [./kdeconnect.nix];

  home-manager.users.${user}.home.file.".config/hypr/per-app/kdeconnect.conf" = {
    text = ''
      exec-once = sleep 3 kdeconnect-indicator
    ''; # why wont this shit work for me :(
  };

  networking = {
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714; # kdeconnect TODO get working
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714; # kdeconnect
          to = 1764;
        }
      ];
    };
  };
}
