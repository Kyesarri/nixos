# ./home/home.nix
# this will be refactored, with minimal configuration left, may rename to default.nix for commonly used 
{
  inputs,
  pkgs,
  ...
}: {
  home-manager.useUserPackages = true; # install packages to /etc/profiles instead of ~/.nix-profile
  home-manager.useGlobalPkgs = true; # this saves an extra Nixpkgs evaluation, adds consistency,
  # and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.users.kel = {
    pkgs,
    config,
    inputs,
    outputs,
    ...
  }: {
  
    imports = [
      inputs.ags.homeManagerModules.default # imports from root flake.nix then builds the package which is nice :)
      ../variables.nix
    ]; 
    
    programs.ags = {
      enable = true; # still need to enable the package
      configDir = ./ags; # sets to /home/kel/.config/ags
    };
    
    programs.home-manager.enable = true;
    xdg.enable = true;
    home.username = config.vars.username;
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.05";

    programs.git = {
      enable = true;
      extraConfig = {
        credential.helper = "libsecret";
      };
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
}
# ./home/home.nix

