{
  lib,
  config,
  spaghetti,
  ...
}:
with lib; let
  cfg = config.gnocchi.ags;
in {
  options.gnocchi.ags = {
    enable = mkEnableOption "enable ags shell"; # will be gnocchi.ags.enable = true; in host.nix
    # foo = mkOption {
    # make an option for foo
    # type = types.str; # string, makes sense
    # default = "bar"; # set a sane default, bar works..., or nothing if we want chaos
    # };
  };

  config = mkIf cfg.enable {
    security.pam.services.ags = {};
    home-manager.users.${spaghetti.user} = {
      programs.ags.enable = true;
      #
      # TODO editing directly from .config to avoid so-many rebuilds :D
      #
      /*
      home.file.".config/ags/" = {
        source = ./config; # symlink whole ~/nixos/home/ags/config dir, leaving some other files to nix, for nix-colors passthrough
        recursive = true; # all subfolders and files
      };
      */
      #
      # add back once ags is "complete" # TODO sync current changes to cbg / ghub
      #
      home.file.".config/hypr/per-app/ags.conf" = {
        text = ''
          exec-once = sleep 2 && ~/nixos/scripts/ags.sh
        '';
        # ^ script reloads / launches ags, outputs logs to tmp dir
      };
      home.file.".config/ags/colours.css" = {
        text = ''
          @define-color c0 #${config.colorscheme.palette.base00};
          @define-color c1 #${config.colorscheme.palette.base01};
          @define-color c2 #${config.colorscheme.palette.base02};
          @define-color c3 #${config.colorscheme.palette.base03};
          @define-color c4 #${config.colorscheme.palette.base04};
          @define-color c5 #${config.colorscheme.palette.base05};
          @define-color c6 #${config.colorscheme.palette.base06};
          @define-color c7 #${config.colorscheme.palette.base07};
          @define-color c8 #${config.colorscheme.palette.base08};
          @define-color c9 #${config.colorscheme.palette.base09};
          @define-color ca #${config.colorscheme.palette.base0A};
          @define-color cb #${config.colorscheme.palette.base0B};
          @define-color cc #${config.colorscheme.palette.base0C};
          @define-color cd #${config.colorscheme.palette.base0D};
          @define-color ce #${config.colorscheme.palette.base0E};
          @define-color cf #${config.colorscheme.palette.base0F};
        '';
      };
      # ^ define nix-colors palette, each device has this defined in /hosts/foo/default.nix
    };
  };
}
