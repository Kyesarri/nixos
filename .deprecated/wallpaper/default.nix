{
  pkgs,
  # nix-colors,
  inputs,
  spaghetti,
  config,
  lib,
  ...
}: let
  inherit
    (inputs.nix-colors.lib-contrib {inherit pkgs;})
    nixWallpaperFromScheme
    ;
in rec {
  wallpaper = {
    enable = true;
    path = lib.mkDefault (nixWallpaperFromScheme {
      scheme = config.colorScheme;
      width = 1920;
      height = 1080;
      logoScale = 4;
    });
  };
}
