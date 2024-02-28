{
  pkgs,
  # nix-colors,
  inputs,
  spaghetti,
  config,
  lib,
  scheme,
  ...
}: let
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) nixWallpaperFromScheme;
in {
  programs.hyprland = {
    wallpaper = {
      enable = true;
      path = lib.mkDefault (nixWallpaperFromScheme {
        scheme = inputs.nix-colors.colorSchemes.${scheme};
        width = 1920;
        height = 1080;
        logoScale = 4;
      });
    };
  };
}
