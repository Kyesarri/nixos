{
  config,
  pkgs,
  spaghetti,
  inputs,
  outputs,
  ...
}: {
  networking = {
    networkmanager.enable = true; # nwm
  };
  users.users.${spaghetti.user}.packages = with pkgs; [networkmanagerapplet];
  home-manager.users.${spaghetti.user} = {
    home.file.".config/hypr/per-app/wireless.conf" = {
      text = ''exec-once = nm-applet'';
    };
  };
}
