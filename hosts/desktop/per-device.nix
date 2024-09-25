{spaghetti, ...}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-device.conf" = {
    text = ''monitor=,3840x1600@144,auto,1'';
  };
}
