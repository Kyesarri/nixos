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

  #
  config = mkMerge [
    (mkIf (clipse-shell.enable == true) {
      users.users.${spaghetti.user}.packages = with pkgs; [clipse];
      # hypr copyq settings
      home.file.".config/hypr/per-app/copyq.conf" = {
        text = ''
          exec-once = sleep 3 && clipse -listen
          # windowrule = float, title:CopyQ
        '';
      };
    })
  ];
}
