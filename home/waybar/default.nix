{
  pkgs,
  spaghetti,
  ...
}: {
  imports = [
    ./config.jsonc.nix
    ./style.css.nix
  ];

  home-manager.users.${spaghetti.user} = {
    programs.waybar = {
      enable = true;
      package = pkgs.waybar.override (oldAttrs: {pulseSupport = true;});
    };
    home.file.".config/hypr/per-app/waybar.conf" = {
      text = ''
        exec-once = waybar
      '';
    };
  };
}
