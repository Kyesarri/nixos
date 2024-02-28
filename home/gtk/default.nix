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
  home-manager.users.${spaghetti.user}.gtk = {
    enable = true;
    theme = {
      name = "${config.colorScheme.slug}";
      package = gtkThemeFromScheme {scheme = config.colorScheme;};
    };
  };
}
