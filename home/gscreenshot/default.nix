{
  lib,
  pkgs,
  config,
  spaghetti,
  inputs,
  ...
}:
with lib; let
  cfg = config.gnocchi.gscreenshot; # shorthand some lines
in {
  # wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
  # libmkafter looks vvv interesting
  options.gnocchi = {
    gscreenshot = {
      enable = mkEnableOption "enable gscreenshot"; # will be gnocchi.hypr.enable = true; in host.nix
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      #
      programs.gscreenshot.enable = true; # enable hyprland, needed w below?
      home-manager.users.${spaghetti.user} = {
        
        # move to gscreenshot under home, TODO #
## take fullscreen screenshot and send to /user/screenshots/
bind = ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/screenshot_$hx$w_%Y-%m-%d%M-%S.png' -n
## open screenshot selection tool with overlay, once region selected send to /user/screenshots/
bind = shift ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/snip_$hx$w_%Y-%m-%d%M-%S.png' -n -s
