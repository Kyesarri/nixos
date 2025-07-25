{
  pkgs,
  inputs,
  config,
  spaghetti,
  ...
}: let
  inherit (inputs.nix-colors.lib-contrib {inherit pkgs;}) gtkThemeFromScheme;
  #
  cursorPkg = pkgs.oreo-cursors-plus;
  cursorName = "oreo_spark_black_bordered_cursors";
  cursorSize = 24;
  themeName = "Jasper-Dark-Compact";
  #
in {
  #
  users.users.${spaghetti.user}.packages = [
    (pkgs.callPackage ../../package/gtk/default.nix {})
    (pkgs.callPackage ../../package/icons/default.nix {})
    # pkgs.zafiro-icons
    pkgs.libsForQt5.qt5ct
    pkgs.libsForQt5.qtstyleplugins
    (pkgs.oreo-cursors-plus.override {
      cursorsConf = ''
        spark_black_bordered = color: ${config.colorscheme.palette.base00}, stroke: ${config.colorscheme.palette.base07}, stroke-width: 4, stroke-opacity: 1
        sizes = 24
      '';
    })
  ];

  environment = {
    sessionVariables = {
      XCURSOR_THEME = cursorName;
      GTK_THEME = themeName;
      # sets default gtk theme the package built by nix-colors
      # GTK_THEME = "${config.colorscheme.slug}";
    };
  };

  qt.platformTheme = "qt5ct";

  home-manager.users.${spaghetti.user} = {
    fonts.fontconfig.enable = true;

    home.pointerCursor = {
      package = cursorPkg;
      name = cursorName;
      size = cursorSize;
    };

    home.sessionVariables = {
      XCURSOR_PATH = "${pkgs.oreo-cursors-plus}/share/icons";
      XCURSOR_THEME = cursorName;
      XCURSOR_SIZE = cursorSize;
    };

    gtk = {
      enable = true;
      theme = {
        name = themeName;
        package = "${(pkgs.callPackage ../../package/gtk/default.nix {})}";
        # name = "${config.colorScheme.slug}";
        # package = gtkThemeFromScheme {scheme = config.colorScheme;};
      };

      iconTheme = {
        package = "${(pkgs.callPackage ../../package/icons/default.nix {})}";
        name = "Zafiro-icons-Dark";
      };

      cursorTheme = {
        package = cursorPkg;
        name = cursorName;
        size = cursorSize;
      };
    };
  };
}
