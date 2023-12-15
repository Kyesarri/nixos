{...}: {
  home-manager.users.kel.home.file.".config/hypr/per-device.conf" = {
    text = ''
      monitor=,1366x768@60,auto,1
      #TODO wonder if that is 60hz :D
    '';
  };
}
