{
  pkgs,
  inputs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = with pkgs; [
    # ulauncher
    inputs.ulauncher.packages."${pkgs.system}".default
  ];

  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/ulauncher.conf" = {
    text = ''
      exec-once = sleep 1 && ulauncher --hide-window
      # windowrulev2 = noborder, class:^(Ulauncher)$
      # windowrulev2 = noshadow, class:^(Ulauncher)$
      windowrulev2 = noblur, class:^(Ulauncher)$
      windowrulev2 = center 1, class:^(Ulauncher)$
      # bind = $mainMod, R, exec, ulauncher-toggle
    '';
  };

  imports = [
    ./manifest.json.nix
    ./theme-gtk-3.20.css.nix
    ./theme.css.nix
  ];
}
