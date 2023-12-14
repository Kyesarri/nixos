{pkgs, ...}: {
  home-manager.users.kel.programs.vscode = {
    enable = true;
    userSettings = {
      "window.titleBarStyle" = "custom"; # this fixed most crashes in codium, will need to wipe config file or add manually :)
    };
    package = pkgs.vscodium;
    extensions = with pkgs.vscode-extensions; [
      enkia.tokyo-night
      yzhang.markdown-all-in-one
      kamadorueda.alejandra
      bbenoist.nix
    ];
  };

  home-manager.users.kel.home.file.".config/hypr/per-app/codium.conf" = {
    text = ''
      windowrule = tile, title:VSCodium
      bind = $mainMod, K, exec, codium
    '';
  };
}
