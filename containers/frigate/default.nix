{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.frigate = {
    autoStart = true;
    privateNetwork = true; # seperate from host network interface
    hostBridge = "br0";
    localAddress = "192.168.87.7/24"; # container ip

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
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

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

        frigate = {
          enable = true;
          hostname = "frigate.nix-serv";

          settings = {
            mqtt.enabled = false;
            ffmpeg.hwaccel_args = "preset-vaapi";
            go2rtc = {
              streams = {
                "entry" = ["rtsp://user:password@192.168.87.22:554/h264Preview_01_sub"];
                "driveway" = ["rtsp://user:password@192.168.87.20:554/h264Preview_01_sub"];
              };
            };

            cameras = {
              entry = {
                ffmpeg.inputs = [
                  {
                    path = "rtmp://user:password@192.168.87.22:1935";
                    roles = ["rtmp"];
                  }
                  {
                    path = "rtsp://user:password@192.168.87.22:554/h264Preview_01_main";
                    input_args = "preset-rtsp-restream";
                    roles = ["record" "detect"];
                  }
                ];
              };

              driveway = {
                ffmpeg.inputs = [
                  {
                    path = "rtsp://user:password@192.168.87.20:554/h264Preview_01_main";
                    roles = ["record" "detect"];
                    input_args = ["preset-rtsp-restream"];
                  }
                  {
                    path = "rtmp://user:password@192.168.87.20:1935";
                    roles = ["rtmp"];
                  }
                ];
              };
            };

            record = {
              enabled = true;
              retain = {
                days = 7;
                mode = "all";
              };
            };
          };
        };
      };
    };
  };
}
