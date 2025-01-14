{
  config,
  secrets,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user} = {
    extraGroups = [
      "moonraker"
    ];
  };
  # barebones - needs way more including webcam / other configs
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
      address = "0.0.0.0";
      #
      settings = {
        globalSection = {
          klippy_uds_address = "/var/lib/moonraker/printer_data/comms/klippy.sock";
        };
        announcements = {
          subscriptions = ["mainsail"];
        };
        authorization = {
          force_logins = true;
          trusted_clients = ["${secrets.ip.subnet}/24" "127.0.0.1/32"];
          cors_domains = ["*.home"];
        };
        file_manager = {
          enable_object_processing = true;
        };
        history = {};
        update_manager = {
          refresh_interval = 168;
          enable_auto_refresh = true;
        };

        octoprint_compat = {};
      };
    };
  };
}
