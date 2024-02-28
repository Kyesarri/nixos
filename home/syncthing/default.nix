{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      exec-once = sleep 3 && syncthing
      exec-once = sleep 10 && syncthingtray
      windowrule = float, title:Syncthing Tray
      windowrulev2 = size 1000 600, title:Syncthing Tray
    '';
  };

  services = {
    syncthing = {
      systemService = true;
      enable = true;
      user = "${spaghetti.user}";
    };
  };

  users.users.${spaghetti.user}.packages = with pkgs; [
    # syncthing
    syncthingtray
  ];
}
