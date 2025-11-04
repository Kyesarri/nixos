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
  options.gnocchi.niri.enable = mkOption {
    type = types.bool;
    default = false;
  };

  config = mkMerge [
    (mkIf (cfg.niri.enable == true) {
      programs.niri = {
        enable = true;
        # package = pkgs.niri-unstable;
      };
    })
  ];
}
