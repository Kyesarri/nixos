{
  config,
  pkgs,
  ...
}:
{
  users.users.kel.packages = with pkgs; [ lite-xl ];
  home-manager.users.kel.home.file."./.config/lite-xl/plugins/nix.lua".source = ./nix.lua; # symlink from this dir to defined dir
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];
}
