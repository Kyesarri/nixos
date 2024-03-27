{
  config,
  pkgs,
  lib,
  ...
}: {
  # declare some basicboi host settings for container
  containers.frigate = {
    /*
    # to use later, hardware passthrough?
    allowedDevices = [
      {
        modifier = "rw";
        node = "/dev/net/tun";
      }
    ];
    */
    autoStart = true;
    privateNetwork = true; # seperate from host network interface
    hostBridge = "br0";
    localAddress = "192.168.87.7/24"; # container ip

    # container nix config

    config = {
      config,
      pkgs,
      ...
    }: {
      system.stateVersion = "23.11";

      networking = {
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = false;
          allowedTCPPorts = [80];
        };
        # workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      environment.systemPackages = with pkgs; [ffmpeg_5-full];

      services = {
        go2rtc = {
          enable = true;
          settings = {
            rtsp.listen = ":8554";
            webrtc.listen = ":8555";
            streams = {
              "entry" = ["rtsp://user:password@192.168.87.22:554/h264Preview_01_sub"];
              "driveway" = ["rtsp://user:password@192.168.87.20:554/h264Preview_01_sub"];
            };
          };
        };

        resolved.enable = true;

        # frigate container service
        frigate = {
          enable = true;
          hostname = "frigate.nix-serv";

          # settings written to /var/lib/frigate/frigate.yml its not?
          settings = {
            mqtt.enabled = false;
            # ffmpeg.hwaccel_args = "preset-vaapi"; # generic intel < 10th gen
            ffmpeg.hwaccel_args = "preset-intel-qsv-h264"; # quicksync > 10th gen

            record = {
              enabled = true;
              retain = {
                days = 2;
                mode = "all";
              };
            };

            go2rtc = {
              streams = {
                "entry" = ["rtsp://user:password@192.168.87.22:554/h264Preview_01_sub"];
                # "driveway" = ["rtsp://user:password@192.168.87.20:554/h264Preview_01_sub"];
              };
            };

            # detectors.ov = {
            #   type = "openvino";
            #   device = "AUTO";
            #   model.path = "/var/lib/frigate/openvino-model/ssdlite_mobilenet_v2.xml";
            # };

            cameras = {
              entry = {
                ffmpeg.inputs = [
                  {
                    "path" = "rtmp://user:password@192.168.87.22:1935/h264Preview_01_sub";
                    roles = ["rtmp" "detect" "record"];
                  }
                  #{
                  #  "path" = "rtsp://user:password@192.168.87.22:554/h264Preview_01_main";
                  #  input_args = "preset-rtsp-restream";
                  #  roles = ["record"];
                  #}
                ];
              };

              driveway = {
                ffmpeg.inputs = [
                  {
                    path = "rtsp://user:password@192.168.87.20:554/h264Preview_01_main";
                    roles = ["record" "detect"];
                  }
                  #{
                  #  path = "rtmp://user:password@192.168.87.20:1935";
                  #  roles = ["rtmp"];
                  #}
                ];
              };
            };
          };
        };
      };
    };
  };
}
