{secrets, ...}: {
  containers.fweedee = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "${secrets.ip.erying}";
    localAddress = "10.231.136.2";
    bindMounts = {
      # pass usb printer by-id to container
      "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0" = {
        hostPath = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        isReadOnly = false;
      };
      # webcam passthrough
      "/dev/v4l/by-id/usb-Alpha_Imaging_Tech._Corp._Razer_Kiyo-video-index0" = {
        hostPath = "/dev/v4l/by-id/usb-Alpha_Imaging_Tech._Corp._Razer_Kiyo-video-index0";
        isReadOnly = false;
      };
    };

    config = {
      lib,
      config,
      ...
    }: {
      system.stateVersion = "23.11";

      services = {
        resolved.enable = true;

        moonraker = {
          enable = true;
          port = 7125;
          allowSystemControl = true;
          address = "0.0.0.0";
          klipperSocket = config.services.klipper.apiSocket;
          settings = {
            authorization = {
              cors_domains = [
                "https://mainsail.zar.red"
                "http://192.168.86.200:8001"
                "http://sankara:8001"
                "*.home"
              ];
              trusted_clients = [
                "192.168.87.0/24"
                "127.0.0.1"
              ];
            };
            file_manager.enable_object_processing = true;
            announcements.subscriptions = ["mainsail"];
          };
        };

        klipper = {
          enable = true;
          mutableConfig = true;
          mutableConfigFolder = "/var/lib/moonraker/config";
          logFile = "/var/lib/moonraker/logs/klipper.log";
          inputTTY = "/run/klipper/tty";
          apiSocket = "/run/klipper/api";
          configFile = "/var/lib/moonraker/config/printer.cfg";
        };
        # mainsail and fluidd conflict
        # error: The option `containers.fweedee.services.nginx.virtualHosts.localhost.root' has conflicting definition values
        /*
        mainsail = {
          enable = true;
        };
        */
        fluidd = {
          enable = true;
        };
        /*
        traefik = {
          enable = true;
          staticConfigOptions = {
            log.level = "DEBUG";

            api = {};
            entryPoints = {
              http = {
                address = ":80";
              };
              https = {
                address = ":443";
              };
              web = {
                address = ":8080";
              };
            };
          };
        };
        */
      };

      networking = {
        useHostResolvConf = lib.mkForce false;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443 7125 8080];
        };
      };
      security.polkit.enable = true;
    };
  };
}
