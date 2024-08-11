{
  secrets,
  lib,
  ...
}: let
  contName = "frigate";
  rtmp = 1935;
  web = 5000;
  rtsp = 8554;
  webRTC = 8555;
  dir1 = "/etc/oci.cont/${contName}/db";
  dir2 = "/etc/oci.cont.scratch/${contName}/media/frigate";
  dir3 = "/etc/oci.cont/${contName}/config";
in {
  system.activationScripts.makeFrigateDir = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} ${toString dir2} ${toString dir3}
  '';

  # tempdir for frigate
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/blakeblackshear/frigate:stable";
    ports = [
      "${toString rtmp}:${toString rtmp}"
      "${toString web}:${toString web}"
      "${toString rtsp}:${toString rtsp}"
      "${toString webRTC}:${toString webRTC}/tcp"
      "${toString webRTC}:${toString webRTC}/udp"
    ];

    volumes = [
      "${toString dir1}:/db"
      "${toString dir2}:/media/frigate"
      "${toString dir3}/:/config"
      "/etc/localtime:/etc/localtime:ro"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.frigate}"
      "--privileged"
      "--shm-size=256m"
      "--device=/dev/apex_0:/dev/apex_0" # coral
      "--device=/dev/dri/renderD128" # gpu
      "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000" # tempfs
    ];
  };

  environment.etc."oci.cont/${contName}/config/config.yml" = {
    mode = "644";
    uid = 1000;
    gid = 1000;
    text = ''
      ##
      go2rtc:
        streams:
          driveway:
            - ffmpeg:rtsp://${secrets.user.drivecam}:${secrets.password.drivecam}@${secrets.ip.drivecam}:554/h264Preview_01_main
            - "ffmpeg:driveway#audio=opus"
          entry:
            - ffmpeg:rtsp://${secrets.user.entrycam}:${secrets.password.entrycam}@${secrets.ip.entrycam}:554/h264Preview_01_main
            - "ffmpeg:entry#audio=opus"
          front:
            - ffmpeg:rtsp://${secrets.user.frontcam}:${secrets.password.frontcam}@${secrets.ip.frontcam}:554/h264Preview_01_main
            - "ffmpeg:entry#audio=opus"
      #
      cameras:
        driveway:
          best_image_timeout: 60
        zones:
          carpark:
            coordinates: 0,0.525,0.409,0.144,0.408,0.256,0.598,0.294,0.555,0.697,0.515,1,0,1
            loitering_time: 0
          lawn:
            coordinates: 0.602,0.298,0.558,0.729,0.998,0.798,0.998,0.397
            loitering_time: 0
          ffmpeg:
            inputs:
            - path: rtsp://127.0.0.1:8554/driveway
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
      #
        entry:
          best_image_timeout: 60
          motion:
            mask:
              - 0,0,0.586,0,0.583,0.019,0.24,0.07,0,0.38
              - 0.187,0.132,0.209,0.493,0.224,0.768,0.268,1,0,1,0,0.368
          ffmpeg:
            inputs:
            - path: rtsp://127.0.0.1:8554/entry
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
      #
        front:
          best_image_timeout: 60
          zones:
            lawn:
              coordinates:
                0.088,0.254,0.459,0.224,0.841,0.265,0.98,0.579,0.967,0.78,0.864,1,0,1,0.001,0.332
              loitering_time: 0
          ffmpeg:
            inputs:
            - path: rtsp://127.0.0.1:8554/front
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
      #
      #
      ffmpeg:
        # hwaccel_args: preset-intel-qsv-h264
        hwaccel_args: preset-vaapi
      #
      database:
        path: /db/frigate.db
      #
      detect:
        enabled: true
        fps: 5
        width: 1920
        height: 1440
      #
      logger:
        default: info
        logs:
          peewee: info
          ws4py: info
      #
      motion:
        threshold: 90
        improve_contrast: true
      #
      mqtt:
        client_id: ${secrets.user.frigate-emqx}
        enabled: true
        host: ${secrets.ip.emqx}
        password: ${secrets.password.frigate-emqx}
        port: 1883
        stats_interval: 60
        topic_prefix: frigate
        user: ${secrets.user.frigate-emqx}
      #
      timestamp_style:
        position: "tl"
        format: "%d/%m/%Y %H:%M:%S"
        effect: shadow
        thickness: 3
        color:
          red: 255
          green: 255
          blue: 255
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
        sync_recordings: false
      #
      # rtmp:
      #   enabled: false
      #
      snapshots:
        enabled: true
        bounding_box: true
        clean_copy: true
        crop: false
        quality: 90
        timestamp: true
      #
      ui:
        time_format: browser
        # live_mode: mse
      #
      # using onboard coral v
      detectors:
        coral_pci:
          type: edgetpu
          device: pci
      #
      birdseye:
        enabled: false
        # width: 640
        # height: 480
      #
    '';
  };
}
