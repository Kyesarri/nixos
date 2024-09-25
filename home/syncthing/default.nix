{
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/syncthing.conf" = {
      # hyprland binds and window rules
      text = ''
        # exec-once = sleep 10 && syncthing
        exec-once = sleep 10 && syncthingtray
        windowrule = float, title:Syncthing Tray
        windowrulev2 = size 1000 600, title:Syncthing Tray
      '';
    };
  };

  services = {
    syncthing = {
      enable = true;
      systemService = true;
      user = "${spaghetti.user}";
      configDir = "/home/${spaghetti.user}/.config/syncthing"; # folder for Syncthing's settings and keys
    };
  };

  # can also enable under ^^ as home-manager.users.${spaghetti.user}.services.syncthing.enable = true;

  # add tray icon
  users.users.${spaghetti.user}.packages = with pkgs; [syncthingtray];
}
