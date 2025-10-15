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
      # todo

      nixpkgs.overlays = [inputs.niri.overlays.niri];
      programs.niri.package = pkgs.niri-unstable;
    })
  ];
}
