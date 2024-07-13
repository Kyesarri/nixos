{
  pkgs,
  spaghetti,
  ...
}: {
  imports = [
    ./theme.nix
    ./init.lua.nix
  ];
  # enable litexl
  users.users.${spaghetti.user}.packages = with pkgs; [lite-xl];
  # symlink from this dir to defined dir
  home-manager.users.${spaghetti.user} = {
    home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua;

    home.file.".config/hypr/per-app/lite-xl.conf" = {
      # hyprland binds and window rules
      text = ''
        bind = $mainMod, K, exec, lite-xl
        windowrule = tile, ^(lite-xl)$
      '';
    };
  };
}
