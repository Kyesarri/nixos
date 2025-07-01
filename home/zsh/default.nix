{spaghetti, ...}: {
  imports = [./theme.nix];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableLsColors = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "line"];
    syntaxHighlighting.patterns = {};
    syntaxHighlighting.styles = {"globbing" = "none";};
    promptInit = "info='n n host kern cpu wm os sh n n' fet.sh";
    ohMyZsh = {
      enable = true;
      custom = "/home/${spaghetti.user}/.config/omzsh/";
      theme = "omzsh-nix";
      plugins = [
        "sudo"
        "terraform"
        "systemadmin"
        "vi-mode"
        "colorize"
      ];
    };
  };
}
