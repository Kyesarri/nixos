{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      exec-once = sleep 3 && syncthingtray
      windowrule = float, title:Syncthing Tray
      windowrulev2 = size 1000 1000, title:Syncthing Tray

    '';
  };

  services = {
    syncthing = {
      enable = true;
      user = "kel";
    };
  };

  users.users.kel.packages = with pkgs; [syncthing syncthingtray];
}
