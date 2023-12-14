{...}: {
  home-manager.users.kel.home.file.".config/hypr/per-device.conf" = {
    text = ''
      exec-once = sleep 2 && openrgb --startminimized
      exec-once = sleep 3 kdeconnect-indicator
    '';
  };
}
