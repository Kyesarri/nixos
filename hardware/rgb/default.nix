{
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/openrgb.conf" = {
    text = ''
      exec-once = sleep 2 && openrgb --startminimized
    '';
  };

  services.udev.packages = [pkgs.openrgb];
  environment.systemPackages = with pkgs; [i2c-tools];
  boot.kernelModules = ["i2c-dev" "i2c-i801"];
  hardware.i2c.enable = true;

  users.users.${spaghetti.user}.packages = with pkgs; [openrgb-with-all-plugins];

  systemd.timers.morning = {
    wantedBy = ["timers.target"];
    partOf = ["rgb-on.service"];
    timerConfig = {
      OnCalendar = "07:00";
      Unit = "rgb-on.service";
    };
  };

  systemd.timers.evening = {
    wantedBy = ["timers.target"];
    partOf = ["rgb-off.service"];
    timerConfig = {
      OnCalendar = "22:30";
      Unit = "rgb-off.service";
    };
  };

  systemd.services.rgb-on = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.openrgb}/bin/openrgb -d RAM -m static -c ffffff
    '';
  };

  systemd.services.rgb-off = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.openrgb}/bin/openrgb -d RAM -m off
    '';
  };
}
