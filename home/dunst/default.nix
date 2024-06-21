{spaghetti, ...}: {
  imports = [./config.nix];

  home-manager.users.${spaghetti.user} = {
    # enable dunst via home-manager
    services.dunst.enable = true;
    # add hyprland bind
    home.file.".config/hypr/per-app/dunst.conf" = {
      text = ''
        bind = $mainMod, X, exec, dunstctl history-pop
      '';
    };
  };
}
