{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = with pkgs; [
    nemo-with-extensions
  ];
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/nemo.conf" = {
      # hyprland binds and window rules
      text = ''
        bind = $mainMod, E, exec, nemo
        windowrule = float, class:nemo
        windowrulev2 = center 1, class:nemo
      '';
    };
  };
}
