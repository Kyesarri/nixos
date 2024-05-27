{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = with pkgs; [cinnamon.nemo-with-extensions];
  home-manager.users.${spaghetti.user} = {
    # home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;

    home.file.".config/hypr/per-app/nemo.conf" = {
      # hyprland binds and window rules
      text = ''
        bind = $mainMod, E, exec, nemo
        windowrule = float, ^(nemo)$
      '';
    };
  };
}
