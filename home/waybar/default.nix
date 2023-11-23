# will refactor into own direcctory soon, might replace with ags when I can focus
{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./config.jsonc.nix
    ./style.css.nix
  ];
  home-manager.users.kel.programs.waybar = {
    enable = true;
    package = pkgs.waybar.override (oldAttrs: {pulseSupport = true;});
  };
}
