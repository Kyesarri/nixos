{spaghetti, ...}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      # monitor = name, resolution(@hz *optional*), position, scale
      monitor = fb0, 1920x1080@60, auto, 1
    '';
  };
}
