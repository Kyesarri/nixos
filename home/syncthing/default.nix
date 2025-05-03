{
  spaghetti,
  secrets,
  pkgs,
  ...
}: {
  # hyprland binds and window rules
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/syncthing.conf" = {
      text = ''
        # exec-once = sleep 10 && syncthing
        exec-once = sleep 10 && syncthingtray
        windowrule = float, title:Syncthing Tray
        windowrulev2 = size 1000 600, title:Syncthing Tray
      '';
    };
  };

  # add tray icon
  users.users.${spaghetti.user}.packages = with pkgs; [syncthingtray];

  # syncthing service
  services = {
    syncthing = {
      enable = true;
      systemService = true;
      # running system service under my user? idk
      user = "${spaghetti.user}";
      # folder for Syncthing's settings and keys
      configDir = "/home/${spaghetti.user}/.config/syncthing";
      # testing
      devices = {
        nix-erying = {
          addresses = ["tcp://${secrets.ip.erying}:51820"];
          id = "${secrets.syncthing.id.nix-erying}";
        };
        p7p = {
          addresses = ["tcp://${secrets.ip.p7p}:51820"];
          id = "${secrets.syncthing.id.p7p}";
        };
      };
    };
  };
}
