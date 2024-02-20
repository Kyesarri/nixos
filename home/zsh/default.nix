{
  pkgs,
  user,
  ...
}: {
  imports = [./theme.nix];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "line"];
    syntaxHighlighting.patterns = {};
    syntaxHighlighting.styles = {"globbing" = "none";};
    promptInit = "info='n host cpu os wm sh n' fet.sh";
    ohMyZsh = {
      enable = true;
      # theme = "$HOME/nixos/home/zsh/fino-time-mod";
      # theme = "omzsh-nix";
      theme = "fino-time";
      plugins = [
        "sudo"
        "terraform"
        "systemadmin"
        "vi-mode"
        "colorize"
        {
          name = "omzsh-nix";
          src = "/home${user}/.config/";
          file = ".omzsh-nix.zsh-theme";
        }
      ];
    };
  };
}
