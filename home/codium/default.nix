{ pkgs, ... }: {
  home-manager.users.kel.programs.vscode = {
    enable = true;
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      yzhang.markdown-all-in-one
      kamadorueda.alejandra
      bbenoist.nix
    ];
  };
}
