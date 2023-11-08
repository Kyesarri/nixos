{ config, pkgs, lib, inputs, outputs, nix-colors, home-manager, ... }: 
let
    inherit (inputs.nix-colors.homeManagerModules.colorScheme { inherit pkgs; }) gtkThemeFromScheme; 
#     inherit (inputs.nix-colors) colorSchemes;
in
{
   home-manager.users.kel = {
   
   gtk = {
     enable = true;
     theme = {
       name = "${config.colorscheme.slug}";
       package = gtkThemeFromScheme { scheme = config.colorscheme; };
     };
   };
 };
}

   # gtk.theme.package = gtkThemeFromScheme {
  #   scheme = config.colorScheme;
  # };
