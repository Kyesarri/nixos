{
  config,
  secrets,
  ...
}: {
  # barebones - notebook to replace rasp pi 3a+ "soon"
  services = {
    #
    mainsail = {
      enable = true;
    };
    #
    klipper = {
      enable = true;
      configFile = ./printer.cfg;
      inherit (config.services.moonraker) user group;
      mutableConfig = true;
      mutableConfigFolder = config.services.moonraker.stateDir + "/config";
    };
    #
    moonraker = {
      enable = true;
      allowSystemControl = true;
      address = "0.0.0.0";
      settings.authorization = {
        force_logins = true;
        trusted_clients = ["${secrets.ip.subnet}/24" "127.0.0.1/32"];
        cors_domains = ["*.home"];
      };
    };
  };
}
