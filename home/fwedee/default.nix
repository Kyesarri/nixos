{...}: {
  # barebones - notebook to replace rasp pi 3a+ "soon"
  services = {
    mainsail = {
      enable = true;
    };
    klipper = {
      enable = true;
      configFile = ./printer.cfg;
    };
    fluidd = {
      enable = true;
    };
    moonraker = {
      enable = true;
    };
  };
}
