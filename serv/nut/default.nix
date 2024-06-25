{...}: {
  power.ups = {
    enable = true;
    mode = "standalone";
    ups.main = {
      description = "Dell UPS 1920R with EBM";
      driver = "usbhid-ups";
      # driver = "blazer_usb";
      port = "auto";
    };
  };
}
