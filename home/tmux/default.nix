{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  users.users.${spaghetti.user}.packages = [pkgs.tmuxifier];

  programs.tmux = {
    enable = true;
    newSession = true; # spawn a new tmux session if trying to attach and none are running
    shortcut = "b";
    programs.tmux.plugins = [
      pkgs.tmuxPlugins.tilish
      pkgs.tmuxPlugins.jump
    ];
  };
}
