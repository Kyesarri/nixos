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
  system.activationScripts.makeFrigateDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} ${toString dir2} ${toString dir3}'';

  # tempdir for frigate
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  # write custom model to container dir
  environment.etc."oci.cont/${contName}/yolov8n_full_integer_quant_edgetpu.tflite" = {
    mode = "644";
    uid = 1000;
    gid = 1000;
    source = ./yolov8n_full_integer_quant_edgetpu.tflite;
  };

  # container config
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
      ## lets setup our camera feeds
      ##
      go2rtc:
        streams:
          driveway:
            - "ffmpeg:http://${secrets.ip.drivecam}/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=${secrets.user.drivecam}&password=${secrets.password.drivecam}#video=copy#audio=copy#audio=opus"
          entry:
            - "ffmpeg:http://${secrets.ip.entrycam}/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=${secrets.user.entrycam}&password=${secrets.password.entrycam}#video=copy#audio=copy#audio=opus"
          front:
            - "ffmpeg:http://${secrets.ip.frontcam}/flv?port=1935&app=bcs&stream=channel0_main.bcs&user=${secrets.user.frontcam}&password=${secrets.password.frontcam}#video=copy#audio=copy#audio=opus"
      ##
      ## now to configure the cameras, zones and motion masks
      ##
      cameras:
        driveway:
          best_image_timeout: 60
          zones:
            carpark:
              coordinates: 0,0.525,0.409,0.144,0.408,0.256,0.598,0.294,0.555,0.697,0.515,1,0,1
              loitering_time: 0
            lawn:
              coordinates: 0.602,0.298,0.558,0.729,0.998,0.798,1,0.38
              loitering_time: 0
              inertia: 3
            nature-strip:
              coordinates: 0.448,0.217,0.412,0.25,1,0.369,1,0.289,0.474,0.191
              inertia: 3
              loitering_time: 0
          ffmpeg:
            output_args:
              record: preset-record-generic-audio-copy
            inputs:
            - path: rtsp://127.0.0.1:8554/driveway
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
              - audio
      #
        entry:
          best_image_timeout: 60
          zones:
            verandah:
              coordinates:
                0.218,0.575,0.419,0.533,0.505,0.682,0.504,0.626,0.516,0.232,0.651,0.331,0.62,0.64,0.844,0.931,0.958,0.59,1,0.633,1,1,0.273,1,0.228,0.766
              loitering_time: 0
              inertia: 3
            door:
              coordinates: 0.512,0.239,0.44,0.187,0.427,0.526,0.496,0.653
              loitering_time: 0
            stairs:
              coordinates:
                0.218,0.566,0.203,0.295,0.341,0.289,0.367,0.278,0.428,0.342,0.426,0.406,0.42,0.523
              loitering_time: 0
            side:
              coordinates: 0.203,0.286,0.332,0.284,0.327,0.136,0.195,0.161
              loitering_time: 0
          motion:
            mask:
              - 0,0,0.586,0,0.583,0.019,0.24,0.07,0,0.38
              - 0.187,0.132,0.209,0.493,0.224,0.768,0.268,1,0,1,0,0.368
          ffmpeg:
            output_args:
              record: preset-record-generic-audio-copy
            inputs:
            - path: rtsp://127.0.0.1:8554/entry
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
              - audio
      #
        front:
          best_image_timeout: 60
          zones:
            lawn:
              coordinates:
                0.088,0.254,0.463,0.242,0.841,0.265,0.98,0.579,0.967,0.78,0.864,1,0,1,0.001,0.332
              loitering_time: 0
              inertia: 3
            nature-strip:
              coordinates:
                0.001,0.227,0.247,0.193,0.521,0.179,0.904,0.23,0.999,0.238,1,0.174,0.731,0.137,0.44,0.113,0.215,0.126,0,0.171
              loitering_time: 0
          ffmpeg:
            output_args:
              record: preset-record-generic-audio-copy
            inputs:
            - path: rtsp://127.0.0.1:8554/front
              input_args: preset-rtsp-restream
              roles:
              - record
              - detect
              - audio
      ##
      ## and the rest of the config lives here
      ##
      ffmpeg:
        hwaccel_args: preset-vaapi
      #
      database:
        path: /db/frigate.db
      #
      detect:
        enabled: true
        fps: 5
        width: 2560
        height: 1920
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
      snapshots:
        enabled: true
        bounding_box: true
        clean_copy: true
        crop: false
        quality: 100
        timestamp: true
      #
      ui:
        time_format: browser
      ##
      ## using onboard coral as a detector
      ##
      detectors:
        coral_pci:
          type: edgetpu
          device: pci
          # testing custom model
          model:
            path: "/yolov8n_full_integer_quant_edgetpu.tflite"
      #
      birdseye:
        enabled: true
        width: 640
        height: 480
      #
    '';
  };
}
