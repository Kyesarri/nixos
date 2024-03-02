{spaghetti, ...}: {
  #programs.kdeconnect.enable = true; # why didnt i use programs.kdeconnect before ffs

  home-manager.users.${spaghetti.user} = {
    services.kdeconnect.enable = true;
    home.file.".config/hypr/per-app/kdeconnect.conf" = {
      text = ''
        exec-once = sleep 3 kdeconnect-indicator
      '';
    };
  };

  networking = {
    firewall = {
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ];
    };
  };
}
