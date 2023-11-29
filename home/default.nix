# ./home/home.nix
# this will be refactored, with minimal configuration left, may rename to default.nix and create another "extras" for other packages
{
  home-manager.users.kel = {
    pkgs,
    lib,
    config,
    inputs,
    outputs,
    nix-colors,
    ...
  }: {
    imports = [
      inputs.ags.homeManagerModules.default # imports from root flake.nix then builds the package which is nice :)
      inputs.nix-colors.homeManagerModules.default
      ./gtk
    ];
    programs.home-manager.enable = true;
    xdg.enable = true;

    home.username = "kel";
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.11";
  };
}
# ./home/home.nix

