{
  config,
  pkgs,
  ...
}: {
  users.users.kel.packages = with pkgs; [lite-xl];
  home-manager.users.kel.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua; # symlink from this dir to defined dir
  imports = [
    ./theme.nix
    ./init.lua.nix
  ];

  home-manager.users.kel.home.file.".config/hypr/per-app/lite-xl.conf" = {
    text = ''
      bind = $mainMod, K, exec, lite-xl
      windowrule = tile, ^(lite-xl)$
    '';
  };
}
# need to rename some of the subfiles here, need to define naming scheme.
# dont mind filename.extension.nix

