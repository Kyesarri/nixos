{
  config,
  pkgs,
  inputs,
  spaghetti,
  ...
}: let
  inherit
    (inputs.nix-colors.lib-contrib {inherit pkgs;})
    gtkThemeFromScheme
    ;
in rec {
  users.users.${spaghetti.user}.packages = [
    pkgs.arc-icon-theme
    # pkgs.moka-icon-theme
  ];

  home-manager.users.${spaghetti.user}.gtk = {
    enable = true;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme {scheme = config.colorScheme;};
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "Arc";
    };
  };
}
