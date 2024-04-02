{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  # make tmpdir for frigate to use, ssd wear bla bla
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  networking.firewall = {
    allowedTCPPorts = [5000 8554 8555];
    allowedUDPPorts = [5000 8555];
  };

  # enable docker
  virtualisation.docker = {enable = true;};

  # adds docker-compose to system packages
  environment.systemPackages = with pkgs; [docker-compose];

  # runs as a systemd service
  ## only issue is that GPU monitoring isn't working from inside
  ## the container, but gpu is working
  virtualisation.oci-containers = {
    backend = "docker";
    containers.frigate = {
      # virtualisation.oci-containers.backend = "docker"; # or podman
      hostname = "frigate";
      autoStart = true;
      image = "ghcr.io/blakeblackshear/frigate:stable"; # or ghcr.io/blakeblackshear/frigate:stable
      ports = [
        # hostPort:containerPort
        "5000:5000"
        "1935:1935"
        "8554:8554" # rtsp
        "8555:8555/tcp" # webrtc
        "8555:8555/udp" # webrtc
      ];
      # environmentFiles = [ ../secrets/frigate.env ]; # TODO
      volumes = [
        "/home/${spaghetti.user}/.docker/frigate:/db"
        "/home/${spaghetti.user}/.docker/frigate:/media/frigate"
        "/home/${spaghetti.user}/.docker/frigate/config.yml:/config/config.yml:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [
        "--shm-size=64m"
        # "--device=/dev/apex_0:/dev/apex_0" # dont have coral yet
        "--device=/dev/dri/renderD128"
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
        "--pull=always"
      ];
    };
  };

  /*
  # use this for standard docker compose running manually
  home-manager.users.${spaghetti.user} = {
  # docker compose.yml
  # can use virtualisation.oci-containers too
  home.file.".docker/frigate/compose.yml" = {
    text = ''
      version: "3.9"
      services:
        frigate: # https://docs.frigate.video/frigate/installation
          container_name: frigate
          privileged: true # needed? to pass-thru hardware (usb? gpu)
          restart: always # why not?
          image: ghcr.io/blakeblackshear/frigate:stable
          shm_size: "128mb" # update for your cameras see installation link above
          devices:
            # - /dev/apex_0:/dev/apex_0 # passes a PCIe Coral, follow driver instructions here https://coral.ai/docs/m2/get-started/#2a-on-linux
            - /dev/dri/renderD128 # for intel hwaccel
          volumes:
          # think this should get some spaghetti, add usernames, other vars
            - /etc/localtime:/etc/localtime:ro
            - /home/${spaghetti.user}/.docker/frigate/config.yml:/config/config.yml
            - /home/${spaghetti.user}/.docker/frigate:/media/frigate
            - /home/${spaghetti.user}/.docker/frigate:/db
            - type: tmpfs # Optional: 1GB of memory, reduces SSD/SD Card wear
              target: /tmp/cache
              tmpfs:
                size: 1000000000
          ports:
            - "5000:5000"
            - "8554:8554" # RTSP feeds
            - "8555:8555/tcp" # WebRTC over tcp
            - "8555:8555/udp" # WebRTC over udp
    '';
  };
  */
  home-manager.users.${spaghetti.user} = {
    # frigate config.yml
    home.file.".docker/frigate/config.yml" = {
      text = ''
        cameras:
          driveway:
            best_image_timeout: 15
            ffmpeg:
              inputs:
              - path: rtsp://127.0.0.1:8554/driveway
                roles:
                - detect
                - record
            motion:
              mask:
              - 1024,0,1024,30,650,30,650,0
            record:
              enabled: true
            zones:
              carpark:
                coordinates: 619,768,0,768,0,370,305,24,311,103,526,94
              verandah:
                coordinates: 1024,768,1024,442,584,465,621,768
          entry:
            ffmpeg:
              inputs:
              - path: rtsp://127.0.0.1:8554/entry
                roles:
                - detect
                - record
            motion:
              mask:
              - 0,768,305,768,170,0,0,0
              - 1024,0,1024,30,650,30,650,0
            record:
              enabled: true

        database:
          path: /db/frigate.db

        ffmpeg:
          hwaccel_args: preset-intel-qsv-h264

        detect:
          enabled: true
          fps: 5
          height: 768
          width: 1024

        go2rtc:
          streams:
            driveway: rtsp://user:password@192.168.87.20:554/h264Preview_01_main
            entry: rtsp://user:password@192.168.87.22:554/h264Preview_01_main

        logger:
          default: info
          logs:
            peewee: info
            ws4py: info

        motion:
          threshold: 100

        mqtt:
          client_id: frigate
          enabled: true
          host: 192.168.87.10
          password: frigate
          port: 1883
          stats_interval: 60
          topic_prefix: frigate
          user: frigate

        objects:
          track:
          - cat
          - person
          - dog
          - bike

        record:
          enabled: true
          events:
            objects:
            - cat
            - person
            - dog
            - bike
            post_capture: 10
            pre_capture: 6
            retain:
              default: 5
              mode: motion
          expire_interval: 60
          retain:
            days: 0
            mode: all
          sync_recordings: true

        rtmp:
          enabled: false

        snapshots:
          bounding_box: true
          clean_copy: true
          crop: false
          enabled: true
          quality: 70
          timestamp: false

        ui:
          time_format: browser

        detectors:
          ov:
            type: openvino
            device: AUTO
            model:
              path: /openvino-model/ssdlite_mobilenet_v2.xml

        model:
          width: 300
          height: 300
          input_tensor: nhwc
          input_pixel_format: bgr
          labelmap_path: /openvino-model/coco_91cl_bkgr.txt

      '';
    };
  };
}
