{
  config,
  pkgs,
  user,
  ...
}: {
  # poweralertd fires off battery / charge notifications from upower
  home-manager.users.${user}.home.file.".config/hypr/per-app/battery.conf" = {
    text = ''
      exec-once = sleep 8 && poweralertd
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
