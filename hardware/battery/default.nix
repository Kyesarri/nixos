{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  # poweralertd fires off battery / charge notifications from upower
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/battery.conf" = {
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
  users.users.${spaghetti.user}.packages = with pkgs; [poweralertd];
}
