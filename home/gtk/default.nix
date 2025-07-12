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
  ];

  environment = {
    # sets default gtk theme the package built by nix-colors
    # GTK_THEME = "${config.colorscheme.slug}";
    # is a user package, may move all theme options in here, and rename
    XCURSOR_THEME = "graphite-dark";
  };

  qt.platformTheme = "qt5ct";

  home-manager.users.${spaghetti.user} = {
    fonts.fontconfig.enable = true;

    home.pointerCursor = {
      package = pkgs.graphite-cursors;
      name = "graphite-dark";
      size = 17;
    };

    home.sessionVariables = {
      XCURSOR_PATH = "${pkgs.graphite-cursors}/share/icons";
      XCURSOR_SIZE = 17;
      XCURSOR_THEME = "graphite-dark";
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
        package = pkgs.graphite-cursors;
        name = "graphite-dark";
        size = 17;
      };
    };
  };
}
