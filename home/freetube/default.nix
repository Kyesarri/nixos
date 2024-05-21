{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi; # shorthand some lines
in {
  options.gnocchi = {
    #
    freetube.enable = mkOption {
      type = types.bool;
      default = false;
    };
    # v unused atm v #
    freetube.config = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (mkIf (cfg.freetube.enable == true) {
      #
      users.users.${spaghetti.user}.packages = [pkgs.freetube]; # enable freetube
    })
    (mkIf (cfg.config.enable == true) {
      #
      # do thing here
    })
  ];
}
