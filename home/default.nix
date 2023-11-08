# ./home/home.nix
# this will be refactored, with minimal configuration left, may rename to default.nix and create another "extras" for other packages

{ home-manager.users.kel = { pkgs, lib, config, inputs, ... }:
let 
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme;
in
 {

    imports = [
      inputs.ags.homeManagerModules.default # imports from root flake.nix then builds the package which is nice :)
      inputs.nix-colors.homeManagerModules.default
      # import default applications between desktop and laptop
      # may need to change shared.nix in hosts?
      ./ags
      ./codium
      ./dunst
      ./firefox
      ./git
      ./gtk
      ./hypr
      ./kde
      ./kitty
      ./lite-xl
      ./swaync
      ./waybar
      ./wcp
      ./wofi
    ]; 

    programs.home-manager.enable = true;
    xdg.enable = true;
    
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.05";
  };
}
# ./home/home.nix

