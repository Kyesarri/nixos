# ./home/home.nix
# this will be refactored, with minimal configuration left, may rename to default.nix and create another "extras" for other packages

{ home-manager.users.kel = { pkgs, lib, config, inputs, outputs, nix-colors, ... }:
 {

    imports = [
      inputs.ags.homeManagerModules.default # imports from root flake.nix then builds the package which is nice :)
      inputs.nix-colors.homeManagerModules.default
      ./gtk
      # import default applications between desktop and laptop
      # may need to change shared.nix in hosts?
    ]; 
    colorscheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # had to add this twice, one in device config and another in here
                                                                   # suggests this base needs further refactor :)

    programs.home-manager.enable = true;
    xdg.enable = true;
    
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.05";
  };
}
# ./home/home.nix

