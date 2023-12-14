{...}: {
  home-manager.users.kel.home.file.".config/hypr/per-device.conf" = {
    text = '''';
  };
  home-manager.users.kel.home.file.".config/hypr/per-app/test.conf" = {
    text = ''
      exec-once = sleep 3 && syncthingtray
    ''; ## fucking works, yee boi
  };
}
