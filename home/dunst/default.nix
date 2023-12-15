{pkgs, ...}: {
  home-manager.users.kel.services.dunst.enable = true;
  imports = [
    ./config.nix
  ];
  home-manager.users.kel.home.file.".config/hypr/per-app/dunst.conf" = {
    text = ''
      bind = $mainMod, X, exec, dunstctl history-pop
    '';
  };
}
