{pkgs, ...}: {
  power.ups = {
    enable = true;

    ups."cp600lcd" = {
      driver = "usbhid-ups";
      port = "auto";
    };

    users.upsmon = {
      passwordFile = "/path/to/upsmon.password";
      upsmon = "master";
    };

    upsmon.monitor."cp600lcd".user = "upsmon";
  };
}
