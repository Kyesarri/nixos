{
  spaghetti,
  pkgs,
  ...
}: {
  users.users.${spaghetti.user}.packages = [
    pkgs.kdePackages.qt6gtk2
    pkgs.kdePackages.qt6ct
    # pkgs.kdePackages.qtstyleplugin-kvantum
  ];
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

  # kdeconnect ports
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
