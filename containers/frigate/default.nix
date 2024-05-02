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

  networking.firewall.allowedTCPPorts = [5000 8554 8555];
  networking.firewall.allowedUDPPorts = [5000 8555];

  virtualisation.oci-containers.containers = {
    #
    frigate = {
      hostname = "frigate-nix-serv";
      autoStart = true;
      image = "ghcr.io/blakeblackshear/frigate:stable";
      ports = [
        # hostPort:containerPort
        "5000:5000" # webui
        "1935:1935" #
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
        "--shm-size=256m"
        # "--device=/dev/apex_0:/dev/apex_0" # enable if using coral in frigate
        "--device=/dev/dri/renderD128" # gpu
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
        "--pull=always" # always want a good pull
      ];
    };
  };
  #
  home-manager.users.${spaghetti.user}.home.file.".docker/frigate/config.yml".text = ''
    # i know passwords are currently exposed here, these are "temp"
    cameras:
    #
      driveway:
        best_image_timeout: 60
        ffmpeg:
          inputs:
    #      - path: rtsp://127.0.0.1:8554/driveway_sub
    #        input_args: preset-rtsp-restream
    #        roles:
    #        - detect
          - path: rtsp://127.0.0.1:8554/driveway
            input_args: preset-rtsp-restream
            roles:
            - record
            - detect
        record:
          enabled: true
    #
      entry:
        best_image_timeout: 60
        ffmpeg:
          inputs:
    #      - path: rtsp://127.0.0.1:8554/entry_sub
    #        input_args: preset-rtsp-restream
    #        roles:
    #        - detect
          - path: rtsp://127.0.0.1:8554/entry
            input_args: preset-rtsp-restream
            roles:
            - record
            - detect
        record:
          enabled: true
    #
    database:
      path: /db/frigate.db
    #
    detect:
      enabled: true
      fps: 10
      height: 1920
      width: 2560
    #
    go2rtc:
      streams:
        driveway:
          - rtsp://frigate:Mj3iNSUJydpaaiT87d65NZgS9kh@192.168.87.20:554/h264Preview_01_main
        entry:
          - rtsp://frigate:Mj3iNSUJydpaaiT87d65NZgS9kh@192.168.87.22:554/h264Preview_01_main
    #    driveway_sub:
    #      - rtsp://frigate:Mj3iNSUJydpaaiT87d65NZgS9kh@192.168.87.20:554/h264Preview_01_sub
    #    entry_sub:
    #      - rtsp://frigate:Mj3iNSUJydpaaiT87d65NZgS9kh@192.168.87.22:554/h264Preview_01_sub
    #
    logger:
      default: info
      logs:
        peewee: info
        ws4py: info
    #
    motion:
      threshold: 90
    # not used currently v
    mqtt:
      client_id: frigate
      enabled: true
      host: 192.168.87.9
      password: $iFQhh^QXu2^r&s%!MX%h969PNW
      port: 1883
      stats_interval: 60
      topic_prefix: frigate
      user: frigate
    #
    objects:
      track:
      - cat
      - person
      - dog
      - bike
      - phone
      - package
    #
    record:
      enabled: true
      events:
        objects:
        - cat
        - person
        - dog
        - bike
        - phone
        - package
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
    #
    rtmp:
      enabled: false
    #
    snapshots:
      bounding_box: true
      clean_copy: true
      crop: false
      enabled: true
      quality: 90
      timestamp: true
    #
    ui:
      time_format: browser
    #
    ffmpeg:
      hwaccel_args: preset-vaapi
    #
    # when cpai v
    detectors:
       deepstack:
         api_url: http://192.168.87.9:32168/v1/vision/detection
         type: deepstack
         api_timeout: 1 # seconds
    #
    # using onboard coral v
    #detectors:
    #  coral_pci:
    #    type: edgetpu
    #    device: pci
    #
    birdseye:
      enabled: true
      width: 640
      height: 480
    #
    #
    #
    #
    #
    #
    #
    #
    #
    # padding at eof
  '';
}
