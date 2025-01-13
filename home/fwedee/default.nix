{secrets, ...}: {
  # barebones - notebook to replace rasp pi 3a+ "soon"
  services = {
    mainsail = {
      enable = true;
    };
    klipper = {
      enable = true;
      configFile = ./printer.cfg;
    };
    /*
    fluidd = {
      enable = true;
    };
    */
    moonraker = {
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true;
      settings.authorization = {
        force_logins = true;
        trusted_clients = ["${secrets.ip.subnet}/24" "127.0.0.1/32"];
        cors_domains = ["*.home"];
      };
    };
  };
}
