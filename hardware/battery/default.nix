{
  config,
  pkgs,
  user,
  ...
}: {
  home-manager.users.${user}.home.file.".config/hypr/per-app/battery.conf" = {
    text = ''
      exec-once = sleep 8 && poweralertd
      exec-once = systemctl start asusd
    '';
  };
  services.upower = {
    enable = true;
    percentageCritical = 10;
    percentageLow = 15;
  };
  users.users.${user}.packages = with pkgs; [poweralertd];
  ## TODO define charge levels somewhere here / in each device
}
