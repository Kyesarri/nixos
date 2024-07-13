{
  config,
  pkgs,
  lib,
  ...
}: {
  services = {
    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        x11.enable =
          if config.services.xserver.enable
          then true
          else false;
        wall.enable = true;
      };
    };
  };
}
