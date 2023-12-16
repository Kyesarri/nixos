{
  pkgs,
  nix-colors,
  ...
}: let
  nix-colors-lib = nix-colors.lib.contrib {inherit pkgs;};
in {
  colorScheme = nix-colors-lib.colorSchemeFromPicture {
    path = ./nixos/wallpaper/wallpaper.png;
    kind = "dark";
  };
}
