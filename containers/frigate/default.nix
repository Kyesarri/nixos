{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.frigate = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.87.7/24";

    config = {
      config,
      pkgs,
      ...
    }: {
      system.stateVersion = "23.11";

      networking = {
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = true;
          allowedTCPPorts = [80];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };

      services = {
        resolved.enable = true;

        go2rtc = {
          enable = false;
          settings = {
            streams = {
              "test1" = [
                "rtsp://10.83.16.12/11"
              ];
            };
            rtsp.listen = ":8554";
            webrtc.listen = ":8555";
          };
        };
        frigate = {
          enable = true;
          hostname = "frigate.nix-serv";

          settings = {
            mqtt.enabled = false;
            ffmpeg.hwaccel_args = "preset-vaapi";

            record = {
              enabled = true;
              retain = {
                days = 7;
                mode = "all";
              };
            };

            cameras = {
              "test1" = {
                ffmpeg.inputs = [
                  {
                    path = "rtsp://127.0.0.1:8554/test1";
                    input_args = "preset-rtsp-restream";
                    roles = ["record"];
                  }
                ];
              };
              "test2" = {
                ffmpeg.inputs = [
                  {
                    path = "rtsp://localaccount:localaccount@172.20.65.103:554/stream1";
                    roles = [
                      "record"
                      "detect"
                    ];
                  }
                ];
              };
            };
          };
        };
      };
    };
  };
}
