# seems to be issues with frigate running in a container - nix containers run as root
# so passing through hardware from the host will fail to run, due to UID issues ( i believe )
# means this config cannot use iGPU for decoding, and am stuck with just CPU decoding
# unless this is to run on metal
# done with the container for now, may look at metal config shortly
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
      # extraFlags = ["-U"];

      # pass intel igpu to container, computer says no
      /*
      allowedDevices = [
        {
          modifier = "rwm";
          node = "/dev/dri/";
        }
      ];
      */
      /*
      bindMounts = {
        dri = rec {
          hostPath = "/dev/dri/";
          mountPoint = hostPath;
          isReadOnly = false;
        };
      };
      */
      config = {
        config,
        pkgs,
        ...
      }: {
        # users.users.root = {extraGroups = ["render" "video"];};
        nixpkgs.config.allowUnfree = lib.mkDefault true; # need unfree for intel drivers
        system.stateVersion = "23.11";
        services.resolved.enable = true; # enabled inside container, wont use host due to bug?
        hardware = {
          enableRedistributableFirmware = lib.mkDefault true; # "might" be required
          opengl = {
            enable = true;
            driSupport = true;
            extraPackages = [
              pkgs.vaapiIntel
              pkgs.libvdpau-va-gl
              pkgs.vaapiVdpau
              pkgs.intel-ocl
              pkgs.intel-media-driver # LIBVA_DRIVER_NAME=iHD
              pkgs.intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
            ];
          };
        };
        networking = {
          hostName = "${hostName}";
          domain = "home.lan";
          useHostResolvConf = lib.mkForce false;
          nameservers = ["192.168.87.1"];
          defaultGateway = "192.168.87.251";
          firewall.allowedTCPPorts = [80 webPort 1984 8555];
        };

        environment = {
          sessionVariables = rec
          {
            XDG_RUNTIME_DIR = "/var/lib/${hostName}";
            LIBVA_DRIVER_NAME = "i965"; # force intel-vaapi-driver
          };
          systemPackages = with pkgs; [
            ffmpeg_5-full
            lshw
            libva-utils
          ];
        };

        systemd.services.frigate = {
          environment.LIBVA_DRIVER_NAME = "i965"; # force intel-vaapi-driver
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
        /*
        toying with triggers
            trigger = {
        "platform" = ["mqtt"];
            };
        topic: frigate/events
        id: frigate-event# force intel-media-driver
        payload: front_cam
        value_template: "{{ value_json['after']['camera'] }}"
        variables:
          after_zones: "{{ trigger.payload_json['after']['entered_zones'] }}"
          before_zones: "{{ trigger.payload_json['before']['entered_zones'] }}"
          camera: "{{ trigger.payload_json['after']['camera'] }}"
          id: "{{ trigger.payload_json['after']['id'] }}"
          label: "{{ trigger.payload_json['after']['label'] }}"
          score: "{{ trigger.payload_json['after']['score'] }}"
          time_clip_start: "{{ trigger.payload_json['after']['start_time'] - 10.0 }}"
          after_attributes: "{{ trigger.payload_json['after']['current_attributes'] }}"
        */
        services.frigate = {
          enable = true;
          hostname = "${hostName}.home.lan";
          settings = {
            cameras = {
              driveway = {
                best_image_timeout = 15;
                record = {enabled = true;};
                motion = {mask = ["1024,0,1024,30,650,30,650,0"];};
                zones.carpark = {coordinates = "619,768,0,768,0,477,362,124,377,200,578,206";};
                ffmpeg = {
                  # input_args = "";
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
                  # input_args = "";
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
              # hwaccel_args = "-hwaccel vaapi -hwaccel_device /dev/dri/renderD128";
              # hwaccel_args = "preset-intel-qsv-h264";
              # hwaccel_args = "preset-vaapi";
              output_args = {
                record = "preset-record-generic-audio-copy";
              };
            };

            mqtt = {
              enabled = true;
              host = "192.168.87.10";
              port = 1883;
              topic_prefix = "frigate";
              client_id = "frigate";
              user = "frigate";
              password = "frigate";
              stats_interval = 60;
            };

            record = {
              enabled = true;
              expire_interval = 60;
              sync_recordings = "true";
              retain = {
                days = 0;
                mode = "all";
              };
              events = {
                pre_capture = 6;
                post_capture = 10;
                objects = ["cat" "person" "dog" "bike"];
                retain = {
                  default = 5;
                  mode = "motion";
                };
              };
            };

            snapshots = {
              enabled = true;
              clean_copy = true;
              timestamp = false;
              crop = false;
              bounding_box = true;
              quality = 70;
            };
            /*
            telemetry = {
              stats = {
                intel_gpu_stats = true;
                network_bandwidth = true;
              };
            };
            */

            ui = {
              use_experimental = true;
              time_format = "browser";
            };

            objects.track = ["cat" "person" "dog" "bike"];
            motion.threshold = 90;
            rtmp.enabled = false;

            # detect stream, used for snapshots, live view, debug
            detect = {
              enabled = true;
              width = 1024;
              height = 768;
              fps = 5;
            };

            # logs not working in container :)
            logger = {
              default = "info";
              logs = {
                peewee = "info";
                ws4py = "info";
                # frigate.mqtt = "error";
              };
            };

            /*
            detectors = {
              # Required: name of the detector
              ov = {
                # Required: type of the detector
                # Frigate provided types include 'cpu', 'edgetpu', 'openvino' and 'tensorrt'
                # Additional detector types can also be plugged in.
                # Detectors may require additional configuration.
                # Refer to the Detectors configuration page for more information.
                type = "openvino";
              };
            };
            */

            /*
            detectors.ov = {
              type = "openvino";
              device = "AUTO";
              # model.path = "${pkgs.frigate}/share/frigate/openvino-model/ssdlite_mobilenet_v2.xml";
            };

            model = {
              width = 300;
              height = 300;
              input_tensor = "nhwc";
              input_pixel_format = "bgr";
              labelmap_path = "${pkgs.frigate}/share/frigate/openvino-model/coco_91cl_bkgr.txt";
            };
            */
          };
        };
      };
    };
  }
