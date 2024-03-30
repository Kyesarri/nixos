let
  hostName = "frigate";
  webPort = 6020;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    containers.${hostName} = {
      autoStart = true;
      privateNetwork = true; # seperate from host network interface
      hostBridge = "br0"; # using bridged interface for containers
      localAddress = "192.168.87.7/24"; # container ip

      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";

        networking = {
          hostName = "${hostName}";
          domain = "home.lan";
          nameservers = ["192.168.87.1"];
          defaultGateway = "192.168.87.251";
          firewall = {
            enable = true;
            allowedTCPPorts = [80 webPort 1984 8555];
          };
          # workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        environment.systemPackages = with pkgs; [ffmpeg_5-full lshw];

        services.resolved.enable = true;

        systemd.services.frigate = {
          LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
          serviceConfig = {
            SupplementaryGroups = ["render" "video"]; # for access to dev/dri/*
            AmbientCapabilities = "CAP_PERFMON";
          };
        };

        # go2rtc was not working for me in the frigate config, added as another service here
        services.go2rtc = {
          enable = true;
          settings = {
            api = {
              listen = ":1984";
              username = "";
              password = "";
            };
            rtsp.listen = ":8554";
            webrtc.listen = ":8555";
            streams = {
              entry = "rtsp://user:password@192.168.87.22:554/h264Preview_01_main";
              driveway = "rtsp://user:password@192.168.87.20:554/h264Preview_01_main";
            };
          };
        };

        services.frigate = {
          enable = true;
          hostname = "${hostName}";
          settings = {
            cameras = {
              driveway = {
                record = {enabled = true;};
                motion = {mask = ["1024,0,1024,30,650,30,650,0"];};
                # zones = {carpark = "coordinates: 619,768,0,768,0,477,362,124,377,200,578,206";};
                ffmpeg = {
                  input_args = "";
                  inputs = [
                    {
                      path = "rtsp://127.0.0.1:8554/driveway";
                      roles = ["detect" "record"];
                    }
                  ];
                };
              };

              entry = {
                record = {enabled = true;};
                motion = {mask = ["0,768,305,768,170,0,0,0" "1024,0,1024,30,650,30,650,0"];};
                ffmpeg = {
                  input_args = "";
                  inputs = [
                    {
                      path = "rtsp://127.0.0.1:8554/entry";
                      roles = ["detect" "record"];
                    }
                  ];
                };
              };
            };

            ffmpeg = {
              hwaccel_args = "preset-vaapi"; # kernel bug?
              output_args = {
                record = "preset-record-generic-audio-copy";
              };
            };

            mqtt = {
              enabled = true;
              host = "haos.home.lan";
              port = 1883;
            };

            record = {
              enabled = true;
              retain = {
                days = 2;
                mode = "active_objects";
              };
            };

            snapshots = {
              enabled = true;
              clean_copy = true;
              timestamp = false;
              crop = false;
              bounding_box = true;
            };

            objects.track = ["cat" "person" "dog"];
            motion.threshold = 90;
            rtmp.enabled = false;

            # detect stream, used for snapshots, live view, debug?
            detect = {
              enabled = true;
              width = 1024;
              height = 768;
              fps = 4;
            };

            # logs not working :)
            #logger = {
            #  default = "info";
            #  logs = {
            #    peewee = "info";
            #    ws4py = "info";
            #    # frigate.mqtt = "error";
            #  };
            #};

            /*

            detectors.ov = {
              type = "openvino";
              device = "AUTO";
              model.path = "/var/lib/frigate/openvino-model/ssdlite_mobilenet_v2.xml";
            };

            model = {
              width = 300;
              height = 300;
              input_tensor = "nhwc";
              input_pixel_format = "bgr";
              labelmap_path = "/openvino-model/coco_91cl_bkgr.txt";
            };
            */
          };
        };
      };
    };
  }
