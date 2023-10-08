# ./modules/fonts.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  fonts = {
    packages = with pkgs; [
      material-design-icons
      inter
      material-symbols
      rubik
      ibm-plex
      (nerdfonts.override {fonts = ["Iosevka" "CascadiaCode" "JetBrainsMono"];})
    ];
  };
}
# ./modules/fonts.nix

