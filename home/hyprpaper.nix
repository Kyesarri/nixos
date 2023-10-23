{config, ...}: {
  home-manager.users.kel.home.file.".config/hypr/hyprpaper.conf" = {
    text = ''
      preload = ~/nixos/wallpaper/5.jpg
      preload = ~/nixos/wallpaper/6.jpg
      preload = ~/nixos/wallpaper/7.jpg
      preload = ~/nixos/wallpaper/8.jpg

      wallpaper = eDP-1, ~/nixos/wallpaper/5.jpg
    '';
  };
}
#preload = ~/nixos/wallpaper/5.jpg
#preload = ~/nixos/wallpaper/6.jpg
#preload = ~/nixos/wallpaper/7.jpg
#preload = ~/nixos/wallpaper/8.jpg

