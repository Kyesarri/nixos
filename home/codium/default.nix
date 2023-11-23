{pkgs, ...}: {
  home-manager.users.kel.programs.vscode = {
    enable = true;
    userSettings = {
      "window.titleBarStyle" = "custom"; # this fixed most crashes in codium
    };
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      yzhang.markdown-all-in-one
      kamadorueda.alejandra
      bbenoist.nix
    ];
  };
}
