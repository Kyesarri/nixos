{
  pkgs,
  user,
  ...
}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "line"];
    syntaxHighlighting.patterns = {};
    syntaxHighlighting.styles = {"globbing" = "none";};
    promptInit = "info='n host cpu os wm sh n' fet.sh";
    ohMyZsh = {
      enable = true;
      theme = "fino-time";
      # theme = "fino-time-mod";
      plugins = ["sudo" "terraform" "systemadmin" "vi-mode" "colorize"];
    };
  };
}
