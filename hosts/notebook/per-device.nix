{spaghetti, ...}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,1366x768@60,auto,1
    '';
  };
}
