{
  pkgs,
  inputs,
  config,
  spaghetti,
  ...
}: let
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
in {
  #
  users.users.${spaghetti.user}.packages = [
    (pkgs.callPackage ../../package/gtk/default.nix {})
    pkgs.zafiro-icons
    pkgs.graphite-cursors
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qtstyleplugins
    (pkgs.oreo-cursors-plus.override {
      cursorsConf = ''
        spark_black_bordered = color: #1C1E26, stroke: #CBCED0, stroke-width: 2, stroke-opacity: 1
        sizes = 24
      '';
    })
  ];

  environment = {
    sessionVariables = {
      XCURSOR_THEME = "oreo_spark_black_bordered_cursors";
      # XCURSOR_THEME = "graphite-dark";
      GTK_THEME = "Jasper-Dark-Compact";
      # sets default gtk theme the package built by nix-colors
      # GTK_THEME = "${config.colorscheme.slug}";
    };
  };

  qt.platformTheme = "qt5ct";

  home-manager.users.${spaghetti.user} = {
    fonts.fontconfig.enable = true;

    home.pointerCursor = {
      package = pkgs.oreo-cursors-plus;
      name = "oreo_spark_black_bordered_cursors";
      # package = pkgs.graphite-cursors;
      # name = "graphite-dark";
      size = 24;
    };

    home.sessionVariables = {
      # XCURSOR_PATH = "${pkgs.graphite-cursors}/share/icons";
      XCURSOR_PATH = "${pkgs.oreo-cursors-plus}/share/icons";
      XCURSOR_SIZE = 24;
      # XCURSOR_THEME = "graphite-dark";
      XCURSOR_THEME = "oreo_spark_black_bordered_cursors";
    };

    gtk = {
      enable = true;
      theme = {
        name = "Jasper-Dark-Compact";
        package = "${(pkgs.callPackage ../../package/gtk/default.nix {})}";
        # below are for nix-colors themes
        # name = "${config.colorScheme.slug}";
        # package = gtkThemeFromScheme {scheme = config.colorScheme;};
      };
      iconTheme = {
        package = pkgs.zafiro-icons;
        name = "Zafiro-icons-Dark";
      };
      cursorTheme = {
        package = pkgs.oreo-cursors-plus;
        name = "oreo_spark_black_bordered_cursors";
        # package = pkgs.graphite-cursors;
        # name = "graphite-dark";
        size = 24;
      };
    };
  };
}
