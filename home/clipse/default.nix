{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi;
in {
  options.gnocchi.clipse.enable = mkOption {
    type = types.bool;
    default = false;
  };
  config = mkMerge [
    (mkIf (cfg.clipse.enable == true) {
      users.users.${spaghetti.user}.packages = with pkgs; [clipse];
      home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/clipse.conf" = {
        text = ''
          exec-once = sleep 3 && clipse -listen
          bind = $mainMod, X, exec, kitty -e clipse
          # windowrule = float, title:clipse
        '';
      };
    })
  ];
}
