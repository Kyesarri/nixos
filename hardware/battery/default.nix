{
  config,
  pkgs,
  user,
  ...
}: {
  # charge limit set to 75% via asusctl, unsure if this works on toshiba
  # poweralertd fires off battery / charge notifications from upower
  home-manager.users.${user}.home.file.".config/hypr/per-app/battery.conf" = {
    text = ''
      exec-once = sleep 8 && poweralertd
      exec-once = systemctl start asusd
      exec-once = sleep 3 && asusctl -c 75
    '';
  };
  # battery monitoring
  services.upower = {
    enable = true;
    percentageCritical = 10;
    percentageLow = 15;
  };
  users.users.${user}.packages = with pkgs; [poweralertd];
}
