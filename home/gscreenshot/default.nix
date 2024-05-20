{
  lib,
  pkgs,
  config,
  spaghetti,
  ...
}:
with lib; let
  cfg = config.gnocchi.gscreenshot;
in {
  options.gnocchi = {
    gscreenshot = {
      enable = mkEnableOption "enable gscreenshot";
    };
  };

  config = mkMerge [
    (
      mkIf (cfg.enable) {
        #
        users.users.${spaghetti.user}.packages = [pkgs.gscreenshot];

        home-manager.users.${spaghetti.user} = {
          home.file.".config/hypr/per-app/gscreenshot.conf" = {
            text = ''
              # # take fullscreen screenshot and send to /user/screenshots/
              bind = ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/screenshot_$hx$w_%Y-%m-%d%M-%S.png' -n
              # # open screenshot selection tool with overlay, once region selected send to /user/screenshots/
              bind = shift ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/snip_$hx$w_%Y-%m-%d%M-%S.png' -n -s
            '';
          };
        };
      }
    )
  ];
}
