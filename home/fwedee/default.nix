{
  config,
  secrets,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user} = {
    # add our user to moonraker group
    extraGroups = ["moonraker"];
  };

  # add moonraker to required groups
  users.users.moonraker = {
    extraGroups = [
      "plugdev" # usb
      "dialout" # serial
      "video" # video
    ];
  };

  # need to copy over macros

  # barebones - needs way more including webcam / other configs
  services = {
    moonraker = {
      user = "moonraker";
      group = "moonraker";
      enable = true;
      address = "0.0.0.0";
      allowSystemControl = true;

      settings = {
        announcements = {
          subscriptions = ["mainsail"];
        };
        authorization = {
          force_logins = true;
          trusted_clients = ["${secrets.ip.subnet}/24" "127.0.0.1/32"];
          cors_domains = ["*.home"];
        };
        server = {
          host = "0.0.0.0";
          port = "7125";
          max_upload_size = "1024"; # in MB
          klippy_uds_address = "/var/lib/moonraker/printer_data/comms/klippy.sock";
        };
        file_manager = {
          enable_object_processing = true;
        };
        history = {};
        octoprint_compat = {};
      };
    };

    mainsail = {
      enable = true;
      hostName = "localhost";
    };

    klipper = {
      enable = true;
      configFile = ./printer.cfg;
      inherit (config.services.moonraker) user group; # same user / group as moonraker
      mutableConfig = true;
      configDir = config.services.moonraker.stateDir + "/config";
    };
  };
}
