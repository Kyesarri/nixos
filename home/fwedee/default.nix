{
  config,
  secrets,
  ...
}: {
  # barebones - notebook to replace rasp pi 3a+ "soon"

  # add some basic lad firewall rules
  networking.firewall = {
    enable = true;
    checkReversePath = "loose"; # fixes connection issues with tailscale
    allowedTCPPorts = [22 80 443];
    allowedUDPPorts = [];
  };

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
      user = "moonraker";
      group = "moonraker";
      enable = true;
      allowSystemControl = true;
      address = "${secrets.ip.notebook}";

      settings = {
        authorization = {
          force_logins = true;
          trusted_clients = ["${secrets.ip.subnet}/24" "127.0.0.1/32"];
          cors_domains = ["*.home"];
        };
      };
    };
  };
}
