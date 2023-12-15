{
  config,
  pkgs,
  ...
}: {
  home-manager.users.kel.home.file.".config/hypr/per-app/battery.conf" = {
    text = ''
      exec-once = sleep 8 && poweralertd
    '';
  };
  services.upower = {
    enable = true;
    percentageCritical = 10;
    percentageLow = 15;
  };
  users.users.kel.packages = with pkgs; [poweralertd];
  ## TODO define charge levels somewhere here / in each device
}
