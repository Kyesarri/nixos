{
  spaghetti,
  pkgs,
  ...
}: {
  # open firewall ranges
  networking.firewall = {
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

  users.users.${spaghetti.user}.packages = [
    pkgs.kdePackages.qtstyleplugin-kvantum
    pkgs.kdePackages.kdeconnect-kde
  ];
  programs.kdeconnect.enable = true;
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/kdeconnect.conf" = {
      text = ''
        exec-once = sleep 3 && kdeconnect-indicator
        windowrulev2 = float, class:^(org.kde.kdeconnect-indicator)$
        windowrulev2 = float, class:^(org.kde.kdeconnect.sms)$
        windowrulev2 = float, class:^(org.kde.kdeconnect.handler)$
      '';
    };
  };
}
