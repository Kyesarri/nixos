# ./home/home.nix
# TODO move wofi / mako to their own nix
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
    imports = [inputs.ags.homeManagerModules.default]; # imports from root flake.nix then builds the package which is nice :)
    programs.ags = {
      enable = true; # still need to enable the package
      configDir = ./ags; # sets to /home/kel/dots/config/ags
    };
    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    home.stateVersion = "23.05";

    services.kdeconnect = {
      enable = true;
      indicator = true;
    };

    programs.home-manager.enable = true;

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

