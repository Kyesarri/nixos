{spaghetti, ...}: {
  home-manager.users.${spaghetti.user} = {
    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    home.file.".config/hypr/per-app/kdeconnect.conf" = {
      text = ''
        exec-once = sleep 3 && kdeconnect-indicator
        windowrulev2 = float, class:^(org.kde.kdeconnect-indicator)$
        windowrulev2 = float, class:^(org.kde.kdeconnect.sms)$
        windowrulev2 = float, class:^(org.kde.kdeconnect.handler)$
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
