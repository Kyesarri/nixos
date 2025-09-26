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
  options.gnocchi = {
    lapce.enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkMerge [
    (
      mkIf (cfg.lapce.enable == true) {
        users.users.${spaghetti.user}.packages = [
          pkgs.lapce # lapce
          pkgs.nil # language server, grumble
        ];
        /*
        home-manager.users.${spaghetti.user}.home.file.".config/lapce-stable/settings.toml" = {
          #
          text = ''
            [ui]
            scroll-width = 15
            [lapce-nix]
            lsp-path = "${pkgs.nil}/bin/nil"
            [core]
            color-theme = "Lapce Dark"
            icon-theme = "Lapce Codicons"
          '';
        };
        */
      }
    )
  ];
}
