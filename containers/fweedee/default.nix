{secrets, ...}: {
  containers.fweedee = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "${secrets.ip.erying}";
    localAddress = "10.231.136.2";

    bindMounts = {
      # usb serial printer passthrough
      /*
      "/dev/ttyUSB0" = {
        hostPath = "/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0";
        isReadOnly = false;
        mountPoint = "/dev/ttyUSB0";
      };
      */
      # webcam passthrough
      "/dev/video1" = {
        hostPath = "/dev/v4l/by-id/usb-Alpha_Imaging_Tech._Corp._Razer_Kiyo-video-index0";
        isReadOnly = false;
        mountPoint = "/dev/video1";
      };

      "/dev/video2" = {
        hostPath = "/dev/v4l/by-id/usb-Alpha_Imaging_Tech._Corp._Razer_Kiyo-video-index1";
        isReadOnly = false;
        mountPoint = "/dev/video2";
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

        mainsail = {
          enable = true;
          nginx = {
            # allow for larger gcode uploads to mainsail
            # clientMaxBodySize = "1000m";
            listen = [
              {
                addr = "127.0.0.1";
                port = 8080;
              }
            ];
          };
        };

        fluidd = {
          enable = true;
        };
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
