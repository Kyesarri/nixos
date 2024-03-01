{
  config,
  pkgs,
  spaghetti,
  ...
}: {
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

  /*
  can also enable under ^^ as home-manager.users.${spaghetti.user} = { services.syncthing.enable = true; ...};
  */

  services = {
    syncthing = {
      enable = true;
      systemService = true;
      user = "${spaghetti.user}";
      configDir = "/home/${spaghetti.user}/.config/syncthing"; # Folder for Syncthing's settings and keys
      /*
      settings = {
        options = {
          startBrowser = false; # stop this boi running every boot, adding -no-browser to exec once in hypr
        };
      };
      */
    };
  };

  users.users.${spaghetti.user}.packages = with pkgs; [
    # syncthing
    syncthingtray
  ];
}
