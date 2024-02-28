{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  imports = [
    ./theme.nix
    ./init.lua.nix
  ];
  users.users.${spaghetti.user}.packages = with pkgs; [lite-xl];

  home-manager.users.${spaghetti.user} = {
    home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua; # symlink from this dir to defined dir

    home.file.".config/hypr/per-app/lite-xl.conf" = {
      text = ''
        bind = $mainMod, K, exec, lite-xl
        windowrule = tile, ^(lite-xl)$
      '';
    };
  };
}
# need to rename some of the subfiles here, need to define naming scheme.
# dont mind filename.extension.nix

