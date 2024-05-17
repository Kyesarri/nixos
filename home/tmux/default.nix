{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.tmuxifier];

  programs.tmux = {
    newSession = true; # spawn a new tmux session if trying to attach and none are running
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    extraConfig = lib.readFile ./default.conf;
    escapeTime = 0;
    keyMode = "vi";
    plugins = [
      pkgs.tmuxPlugins.cpu
      pkgs.tmuxPlugins.tilish
      pkgs.tmuxPlugins.better-mouse-mode
    ];
  };
}
