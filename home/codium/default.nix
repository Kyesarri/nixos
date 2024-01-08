{
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user} = {
    programs.vscode = {
      enable = true;
      userSettings = {
        "window.titleBarStyle" = "custom";
        "terminal.integrated.fontFamily" = "Hack Nerd Font Mono";
        "editor.fontFamily" = "Hack Nerd Font Mono";
      };
      package = pkgs.vscodium;
      extensions = with pkgs.vscode-extensions; [
        enkia.tokyo-night
        yzhang.markdown-all-in-one
        kamadorueda.alejandra
        bbenoist.nix
      ];
    };

    home.file.".config/hypr/per-app/codium.conf" = {
      text = ''
        windowrule = tile, title:VSCodium
        bind = $mainMod, K, exec, codium
      '';
    };
  };
}
