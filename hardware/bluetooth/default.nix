{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "${spaghetti.user}";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "False";
      };
    };
  };

  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/bluetooth.conf" = {
    text = ''
      exec-once = blueman-applet
      # windowrule = float, ^(blueberry.py)$
    '';
  };

  users.users.${spaghetti.user} = {
    packages = with pkgs; [gnome.gnome-bluetooth];
  };
}
