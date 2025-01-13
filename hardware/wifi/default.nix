{
  lib,
  pkgs,
  config,
  spaghetti,
  ...
}:
with lib; let
  cfg = config.gnocchi.wifi;
in {
  # using a shitty workaround - if use cfg.enable || cfg.backend
  # in mkMerge causes the whole module to be interpreted which
  # causes builds to fail due to multiple backends
  # default to none will allow this to be imported
  # by all hosts and default to no backend
  # there -may- be a workaround for this which is more
  # elegant but for now i'm happy with this module
  options.gnocchi = {
    wifi = {
      backend = mkOption {
        type = types.str;
        default = "none";
        example = "iwd, wpa, nwm or none. defaults to none";
      };
    };
  };
  #
  config = mkMerge [
    (mkIf (cfg.backend == "none") {
      networking.wireless.iwd.enable = false;
      networking.wireless.enable = false;
    })
    (mkIf (cfg.backend == "nwm") {
      #
      networking.networkmanager.enable = true; # nwm

      users.users.${spaghetti.user}.packages = with pkgs; [networkmanagerapplet];
      home-manager.users.${spaghetti.user} = {
        home.file.".config/hypr/per-app/wireless.conf" = {
          text = ''exec-once = nm-applet'';
        };
      };
    })
    #
    (mkIf (cfg.backend == ["iwd"]) {
      networking.wireless.iwd.enable = true;
      users.users.${spaghetti.user}.packages = with pkgs; [iwd iwgtk impala];

      home-manager.users.${spaghetti.user} = {
        home.file.".config/hypr/per-app/wireless.conf" = {
          text = ''
            windowrule = float, ^(org.twosheds.iwgtk)$
            windowrule = float, title:Authentication Required
            windowrule = float, title:Wireless network credentials
          '';
        };
        home.file.".config/iwgtk.conf" = {
          text = ''
            #
            # Only specify options that you wish to change. To use an option's default value, leave it
            # commented.
            #
            # Color values may consist of:
            # * A standard name (Taken from the CSS specification).
            # * A hexadecimal value in the form "#rgb", "#rrggbb", "#rrrgggbbb" or "#rrrrggggbbbb"
            # * A hexadecimal value in the form "#rgba", "#rrggbbaa", or "#rrrrggggbbbbaaaa"
            # * A RGB color in the form "rgb(r,g,b)" (In this case the color will have full opacity)
            # * A RGBA color in the form "rgba(r,g,b,a)"
            #
            # Where "r", "g", "b", and "a" are respectively the red, green, blue and alpha color
            # values. In the last two cases, "r", "g", and "b" are either integers in the range 0 to
            # 255 or percentage values in the range 0% to 100%, and "a" is a floating point value in
            # the range 0 to 1.
            #
            # See: https://docs.gtk.org/gdk4/method.RGBA.parse.html
            # List of standard color names: https://developer.mozilla.org/en-US/docs/Web/CSS/color_value/color_keywords
            #

            #
            # Indicator icon colors: station mode
            #

            [indicator.colors.station]
            connected=#${config.colorscheme.palette.base0B}
            connecting=#${config.colorscheme.palette.base0E}
            disconnected=#${config.colorscheme.palette.base04}

            #
            # Indicator icon colors: AP mode
            #

            [indicator.colors.ap]
            #up=lime
            #down=gray

            #
            # Indicator icon colors: ad-hoc mode
            #

            [indicator.colors.adhoc]
            #up=lime
            #down=gray

            #
            # Indicator icon colors: disabled device or adapter
            #

            [indicator.colors.disabled]
            #device=gray
            #adapter=gray

            #
            # Available network list - Signal strength icon colors
            #

            [network.colors]
            connected=#${config.colorscheme.palette.base0B}
            connecting=#${config.colorscheme.palette.base0E}
            known=#${config.colorscheme.palette.base0B}66
            unknown=#${config.colorscheme.palette.base02}
            hidden=#${config.colorscheme.palette.base03}

            #
            # Known network list - last connection date/time - format string
            #

            [known-network]
            #last-connection-time.format=%x\n%l:%M %p

            #
            # Dark mode and window dimensions
            #

            [window]
            #dark=false
            #width=440
            #height=600

          '';
        };
      };
    })
    #
    (mkIf (cfg.backend == "wpa") {
      networking.wireless.enable = true; # wpa
    })
  ];
}
