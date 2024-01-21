{
  pkgs,
  user,
  ...
}: {
  # TODO nix-colors done?
  users.users.${user}.packages = with pkgs; [ulauncher];

  ## TODO might want to toy with the idea of changing the noborder rule and have hypr generate borders for the window
  ## TODO might looks pretty janky however worth testing, while removing ulauncher default border
  ## TODO right now ulauncher has a static coloured border, which is ok but not the theme i'm going for

  home-manager.users.${user}.home.file.".config/hypr/per-app/ulauncher.conf" = {
    text = ''
      exec-once = sleep 1 && ulauncher --hide-window
      windowrulev2 = noborder, class:^(ulauncher)$
      windowrulev2 = noshadow, class:^(ulauncher)$
      windowrulev2 = noblur, class:^(ulauncher)$
      bind = $mainMod, R, exec, ulauncher-toggle
    '';
  };

  imports = [
    ./manifest.json.nix
    ./theme-gtk-3.20.css.nix
    ./theme.css.nix
  ];
}
