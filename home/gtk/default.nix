{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  home-manager,
  ...
}: 
let
    inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme; 
in
{
     gtk = {
       theme = {
         name = "${config.colorscheme.slug}";
         package = gtkThemeFromScheme { scheme = config.colorscheme; };
       };
     };
 }
