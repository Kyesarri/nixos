{ config, inputs, outputs, pkgs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
in
{
  home-manager.users.kel.programs.waybar =
    {
      enable = true;
      package = (pkgs.waybar.override (oldAttrs: { pulseSupport = true;} )); # might want to declare waybar as hyprland is
    };
}