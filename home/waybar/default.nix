{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./config.jsonc.nix
    ./style.css.nix
  ];

  home-manager.users.kel.home.file.".config/hypr/per-app/waybar.conf" = {
    text = ''
      exec-once = waybar
    '';
  };

  home-manager.users.kel.programs.waybar = {
    enable = true;
    package = pkgs.waybar.override (oldAttrs: {pulseSupport = true;});
  };
}
