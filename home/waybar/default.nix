{
  pkgs,
  spaghetti,
  ...
}: {
  imports = [
    ./config.nix
    ./style.nix
  ];

  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/waybar.conf".text = ''exec-once = waybar'';

    programs.waybar = {
      enable = true;
      package = pkgs.waybar.override (oldAttrs: {pulseSupport = true;});
    };
  };
}
