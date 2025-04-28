{
  spaghetti,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi;
in {
  options.gnocchi.lapce = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (mkIf (cfg.lapce.enable == true) {
      users.users.${spaghetti.user}.programs.lapce = {
        enable = true;
        plugins = [];
      };
    })
  ];
}
