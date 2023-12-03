{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users.kel.packages = with pkgs; [
    ulauncher
  ];
  imports = [
    ./manifest.json.nix
    ./theme-gtk-3.20.css.nix
    ./theme.css.nix
  ];
}
