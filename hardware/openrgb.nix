# ./hardware/openrgb.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
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
      ${pkgs.openrgb}/bin/openrgb -d RAM -m static -c ff0000
    '';
  };

  systemd.services.rgb-off = {
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.openrgb}/bin/openrgb -d RAM -m off
    '';
  };
}
# ./hardware/openrgb.nix

