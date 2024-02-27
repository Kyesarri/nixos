{
  config,
  pkgs,
  inputs,
  user,
  ...
}: {
  programs.hyprland.enable = true;
  imports = [./hyprland.nix];
}
