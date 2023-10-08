{config, ...}: {
  home-manager.users.kel.home.file."dots/config/hypr/hyprpaper.conf" = {
    text = ''
      preload = ~/nixos/wallpaper/1.jpg
      preload = ~/nixos/wallpaper/2.jpg
      preload = ~/nixos/wallpaper/3.jpg
      preload = ~/nixos/wallpaper/4.jpg
      wallpaper = eDP-1, ~/nixos/wallpaper/1.jpg
    '';
  };
}
