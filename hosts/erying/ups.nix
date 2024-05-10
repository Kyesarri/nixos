{pkgs, ...}: {
  power.ups = {
    enable = true;
    mode = "netserver";
    ups = {
      usbups = {
        driver = "usbhid-ups";
        port = "auto";
        description = "USB UPS";
        summary = ''
          override.battery.charge.low = 33
        '';
      };
    };
  };

  environment.etc = {
    "nut/upsd.conf".source =
      pkgs.writeText "upsd.conf"
      ''
        LISTEN 127.0.0.1 3493
      '';

    "nut/upsd.users".source =
      pkgs.writeText "upsd.users"
      ''
        [upsmon]
            password  = pass
            upsmon primary
            actions = set
            actions = fsd
            actions = test.panel.start
            instcmds = ALL
      '';

    "nut/upsmon.conf".source =
      pkgs.writeText "upsmon.conf"
      ''
        MONITOR usbups@localhost 1 upsmon pass primary
        MINSUPPLIES 1
        SHUTDOWNCMD "${pkgs.systemd}/bin/systemctl poweroff"
        POLLFREQ 5
        POLLFREQALERT 5
        HOSTSYNC 15
        DEADTIME 15
        POWERDOWNFLAG /etc/killpower
        RBWARNTIME 43200
        NOCOMMWARNTIME 300
        FINALDELAY 5
      '';
  };
}
