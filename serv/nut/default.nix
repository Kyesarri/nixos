# taken config from https://github.com/miniBill/machines-config/blob/b5d88bff6cb72dd95842504152f761239a11dd10/uriel/ups.nix
{...}: let
  vid = "047c";
  pid = "ffff";
  upsName = "1920R";
  pass-master = "masterMonitorPassword"; # master password for nut
  pass-local = "localMonitorPassword"; # slave/local password for nut
in {
  power.ups = {
    enable = true;
    mode = "standalone";
    maxStartDelay = 30;
    ups."${upsName}" = {
      description = "Dell UPS 1920R with EBM";
      driver = "usbhid-ups";
      port = "auto";
      maxStartDelay = null;
      directives = [
        "vendorid = ${vid}"
        "productid = ${pid}"
        "user = nut"
        "group = nut"
        "explore"
      ];
    };
  };

  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTRS{idVendor}=="${vid}", ATTRS{idProduct}=="${pid}", MODE="664", GROUP="nut", OWNER="nut" SYMLINK+="usb/ups"
  '';

  users = {
    users.nut = {
      isSystemUser = true;
      group = "nut";
      # it does not seem to do anything with this directory
      # but something errored without it, so whatever
      home = "/var/lib/nut";
      createHome = true;
    };
    groups.nut = {};
  };
  # reference: https://github.com/networkupstools/nut/tree/master/conf
  environment.etc = {
    # tells upsd to listen on local network (0.0.0.0) for client machines
    upsdConf = {
      text = ''
        LISTEN 127.0.0.1 3493
      '';
      target = "nut/upsd.conf";
      mode = "0440";
      group = "nut";
      user = "nut";
    };
    upsdUsers = {
      # update upsmonConf MONITOR to match
      text = ''
        [monmaster]
            password = "${pass-master}"
            upsmon master

        [monslave]
            password = "${pass-local}"
            upsmon slave
      '';
      target = "nut/upsd.users";
      mode = "0440";
      group = "nut";
      user = "nut";
    };
  };
}
/*
Bus 001 Device 004: ID 047c:ffff Dell Computer Corp. UPS Tower 500W LV
*/

