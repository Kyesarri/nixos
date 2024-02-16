{
  config,
  pkgs,
  user,
  ...
}: {
  services.blueman.enable = true;

  hardware.bluetooth = {
    enable = true;
    settings = {
      General = {
        Name = "${user}";
        ControllerMode = "dual";
        FastConnectable = "true";
        Experimental = "true";
      };
      Policy = {
        AutoEnable = "true";
      };
    };
  };

  home-manager.users.${user}.home.file.".config/hypr/per-app/bluetooth.conf" = {
    text = ''
      # exec-once = blueman-applet
      # windowrule = float, ^(blueberry.py)$
    '';
  };

  users.users.${user} = {
    packages = with pkgs; [gnome.gnome-bluetooth];
  };
}
