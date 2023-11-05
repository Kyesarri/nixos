
 home-manager.users.kel = {
    pkgs,
    config,
    inputs,
    outputs,
    ...
  }:
    inherit (inputs.nix-colors.lib-contrib { inherit pkgs; }) gtkThemeFromScheme; 
  {
     gtk = {
       enable = true;
       theme.package = gtkThemeFromScheme {
         scheme = config.colorScheme;
       };
       theme = {
         name = "${config.colorscheme.slug}";
         package = gtkThemeFromScheme { scheme = config.colorscheme; };
       };
     };
