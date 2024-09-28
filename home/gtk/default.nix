{
  pkgs,
  inputs,
  config,
  spaghetti,
  ...
}: let
  inherit
    (inputs.nix-colors.lib-contrib {inherit pkgs;})
    gtkThemeFromScheme
    ;
in {
  #
  users.users.${spaghetti.user}.packages = [pkgs.zafiro-icons];

  qt.platformTheme = "qt5ct";

  home-manager.users.${spaghetti.user} = {
    home.sessionVariables = {
      XCURSOR_PATH = "${pkgs.graphite-cursors}/share/icons";
      XCURSOR_SIZE = 17;
      XCURSOR_THEME = "graphite-dark";
    };

    gtk = {
      enable = true;
      theme = {
        name = "${config.colorScheme.slug}";
        package = gtkThemeFromScheme {scheme = config.colorScheme;};
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
