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
  HAOSpasswordFile = "${pkgs.writeText "upspass" "test"}";
in {
  /*
    sudo nut-scanner -C -s ip-start -e ip-end
    [nutdev1]
  	driver = "usbhid-ups"
  	port = "auto"
  	vendorid = "047C"
  	productid = "FFFF"
  	product = "Dell UPS Rack 1920W HV"
  	serial = "CN-0H928N-75162-3C4-0039-A10"
  	vendor = "DELL"
  	bus = "001"
  [nutdev2]
  	driver = "snmp-ups"
  	port = "192.168.87.8"
  	desc = "DELL"
  	mibs = "ietf"
  	community = "public"
  [nutdev3]
  	driver = "netxml-ups"
  	port = "http://192.168.87.8"
  	desc = "Mosaic 4M 16M"
  */
  power.ups = {
    enable = true;
    upsd.enable = true;
    openFirewall = true;
    ups.dellups = {
      driver = "snmp-ups";
      port = "${secrets.ip.dellups}:161";
      directives = [
        "snmp_version = v1"
        "community = public"
        "pollfreq = 15"
      ];
    };
    users = {
      haos = {
        actions = ["SET"];
        instcmds = ["ALL"];
        password = "";
      };
      monuser = {
        upsmon = "master";
        actions = ["SET"];
        instcmds = ["ALL"];
        inherit passwordFile;
      };
    };
    upsmon = {
      monitor.dellups = {
        user = "monuser";
        type = "master";
        inherit HAOSpasswordFile;
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
    # add nut group
    groups.nut = {};
    # add nut user
    users.nut = {
      description = "NUT (Network UPS Tools)";
      group = "nut";
      extraGroups = [
        "networkmanager" # networked ups
        "plugdev" # usb ups
      ];
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
