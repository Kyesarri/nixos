{...}: {
  home-manager.users.kel.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,1920x1080@120,auto,1
    '';
  };
}
