{spaghetti, ...}: {
  home-manager.users.${spaghetti.user} = {
    programs.caelestia = {
      enable = true;
      systemd = {
        enable = false; # if you prefer starting from your compositor
        target = "graphical-session.target";
        environment = [];
      };
      settings = {
        bar.status = {
          showBattery = true;
        };
        paths.wallpaperDir = "~/wallpapers";
      };
      cli = {
        enable = true; # Also add caelestia-cli to path
        settings = {
          theme.enableGtk = true;
        };
      };
    };
  };
}
