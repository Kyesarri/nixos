{
  spaghetti,
  pkgs,
  lib,
  ...
}: {
  # currenty not used but added for "future use" - intentions there, not sure about the scope however
  users.users.${spaghetti.user}.packages = [pkgs.tmuxifier];

  programs.tmux = {
    enable = true;
    newSession = true; # spawn a new tmux session if trying to attach and none are running
    aggressiveResize = true;
    baseIndex = 1; # start tabs at 1 vs 0 alt + 1, 2, 3... 0 is just messy
    extraConfig = lib.readFile ./default.conf; # read ./default.conf - add to bottom of tmux config
    escapeTime = 0;
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.tilish
      pkgs.tmuxPlugins.better-mouse-mode
    ];
  };
}
