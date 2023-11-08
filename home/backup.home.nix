# ./home/home.nix
# this will be refactored, with minimal configuration left, may rename to default.nix and create another "extras" for other packages
{ home-manager = {

users.kel = { pkgs, lib, config, inputs, outputs, ... }: {

    imports = [
      inputs.ags.homeManagerModules.default # imports from root flake.nix then builds the package which is nice :)
      inputs.nix-colors.homeManagerModules
    ]; 

    #home.sessionVariables.GTK_THEME = "Generated";
    programs.ags = {
      enable = true; # still need to enable the package
      configDir = ./ags; # sets to /home/kel/.config/ags
    };
    
    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.05";

    programs.git = {
      enable = true;
      extraConfig = {
        credential.helper = "libsecret";
      };
    };

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        yzhang.markdown-all-in-one
        kamadorueda.alejandra
        bbenoist.nix
      ];
    };
  };
};
}
# ./home/home.nix

