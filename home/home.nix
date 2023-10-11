# ./home/home.nix
# TODO move wofi / mako to their own nix
{
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
    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    programs.home-manager.enable = true;
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

