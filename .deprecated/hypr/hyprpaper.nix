{
  config,
  user,
  ...
}: {
  home-manager.users.${user} = {
    home.file.".config/hypr/hyprpaper.conf" = {
      text = ''
        preload = ~/wallpaper/1.jpg
        wallpaper = eDP-1, ~/wallpaper/1.jpg
      '';
      # wallpaper = eDP-1, ~/nixos/wallpaper/5.jpg
      # this value needs to have a configuration for all devices
      ## laptop also needs HDMI added for ultrawide res
      ### should use source as i am in hyprland then add "more" per-device-wallpaper.conf for each machine
      #### messy-ish but a simple workaround
      ##### can use wildcard for all monitor? * or leave blank with comma ", ..."
    };
  };
}
