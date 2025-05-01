{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi.neovim;
in {
  options.gnocchi.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (
      mkIf (cfg.enable == true)
      {
        programs.neovim = {
          enable = true;
          defaultEditor = true;
          viAlias = true;
          vimAlias = true;
        };
      }
    )
  ];
}
