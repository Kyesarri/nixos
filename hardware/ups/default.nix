# taken from https://github.com/accelbread/config-flake/blob/c4acf21d3a34c8bed18e08728d086803fdcd43ea/nix/nixos/solace/ups.nix#L17
{
  spaghetti,
  secrets,
  pkgs,
  lib,
  ...
}: let
  sudo = "/run/wrappers/bin/sudo";
  poweroff = "/run/current-system/sw/bin/poweroff";
  notify-send = pkgs.writeShellScript "notify-send-wrapper" ''
    DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus \
      ${pkgs.libnotify}/bin/notify-send "$@"
  '';
  notifycmd = pkgs.writeShellScript "nut-notifycmd" ''
    ${sudo} -u ${spaghetti.user} ${notify-send} -c critical "$1"
  '';
  passwordFile = "${pkgs.writeText "upspass" "upsmon_pass"}";
in {
  power.ups = {
    enable = true;
    ups.dell = {
      driver = "netxml-ups";
      port = "http://${secrets.ip.dellups}:80";
    };
    users.monuser = {
      upsmon = "master";
      inherit passwordFile;
    };
    upsmon = {
      monitor.dell = {
        user = "monuser";
        type = "master";
        inherit passwordFile;
      };
      settings = {
        RUN_AS_USER = lib.mkForce "nut";
        SHUTDOWNCMD = "${sudo} ${poweroff}";
        NOTIFYCMD = "${notifycmd}";
        NOTIFYFLAG = [
          ["ONLINE" "SYSLOG+EXEC"]
          ["ONBATT" "SYSLOG+EXEC"]
          ["FSD" "SYSLOG+EXEC"]
          ["COMMOK" "SYSLOG+EXEC"]
          ["COMMBAD" "SYSLOG+EXEC"]
          ["SHUTDOWN" "SYSLOG+EXEC"]
          ["REPLBATT" "SYSLOG+EXEC"]
          ["NOCOMM" "SYSLOG+EXEC"]
        ];
      };
    };
  };

  users = {
    groups.nut = {};
    users.nut = {
      description = "NUT (Network UPS Tools)";
      group = "nut";
      isSystemUser = true;
      createHome = true;
      home = "/var/lib/nut";
    };
  };

  services.udev.packages = [pkgs.nut];

  systemd.services = {
    upsd.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.nut}/sbin/upsd -u nut";
    upsmon.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.nut}/sbin/upsmon -u nut";
    upsdrv.serviceConfig.ExecStart =
      lib.mkForce "${pkgs.nut}/bin/upsdrvctl -u nut start";
  };

  security.sudo.extraRules = [
    {
      users = ["nut"];
      runAs = "root";
      commands = [
        {
          command = "${poweroff}";
          options = ["NOPASSWD"];
        }
      ];
    }
    {
      users = ["nut"];
      runAs = "${spaghetti.user}";
      commands = [
        {
          command = "${notify-send}";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
