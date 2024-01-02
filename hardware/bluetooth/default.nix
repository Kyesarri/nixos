{
  config,
  pkgs,
  user,
  ...
}: {
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
      windowrule = float, ^(blueberry.py)$
    '';
  };
  users.users.${user}.packages = with pkgs; [blueberry];
}
