{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.tmuxifier];

  programs.tmux = {
    enable = true;
    newSession = true; # spawn a new tmux session if trying to attach and none are running
    aggressiveResize = true;
    baseIndex = 1;
    extraConfig = lib.readFile ./default.conf;
    escapeTime = 0;
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.tilish
      pkgs.tmuxPlugins.better-mouse-mode
    ];
  };
}
