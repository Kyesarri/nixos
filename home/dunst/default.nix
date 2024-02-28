{
  pkgs,
  spaghetti,
  ...
}: {
  imports = [./config.nix];

  home-manager.users.${spaghetti.user} = {
    services.dunst.enable = true;

    home.file.".config/hypr/per-app/dunst.conf" = {
      text = ''
        bind = $mainMod, X, exec, dunstctl history-pop
      '';
    };
  };
}
