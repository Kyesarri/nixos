{
  config,
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file.".config/hypr/per-app/syncthing.conf" = {
    text = ''
      exec-once = sleep 3 && syncthingtray
      windowrule = float, title:Syncthing Tray
      windowrulev2 = size 1000 600, title:Syncthing Tray
    '';
  };

  services = {
    syncthing = {
      systemService = true;
      enable = true;
      user = "${user}";
    };
  };

  users.users.${user}.packages = with pkgs; [syncthing syncthingtray];
}
