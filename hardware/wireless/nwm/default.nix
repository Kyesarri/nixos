{
  config,
  pkgs,
  user,
  inputs,
  outputs,
  ...
}: {
  networking = {
    networkmanager.enable = true; # nwm
  };
  users.users.${user}.packages = with pkgs; [networkmanagerapplet];
  home-manager.users.${user} = {
    home.file.".config/hypr/per-app/wireless.conf" = {
      text = ''
        exec-once = nm-applet
      '';
    };
  };
}
