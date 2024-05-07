{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "frigate";
  rtmp = 1935;
  web = 5000;
  rtsp = 8554;
  webRTC = 8555;
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/db";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/media/frigate";
  dir3 = "/home/${spaghetti.user}/.containers/${hostName}/config";
in {
  system.activationScripts.makeFrigateDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2} ${toString dir3}
  '';

  # make tmpdir for frigate to use, ssd wear bla bla, probs isnt even working :)
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  networking.firewall.allowedTCPPorts = [web rtsp webRTC];
  networking.firewall.allowedUDPPorts = [web webRTC];

  virtualisation.oci-containers.containers = {
    #
    frigate = {
      hostname = "${hostName}-nix-serv";
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
        "${toString dir3}/config.yml:/config/config.yml:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];

      extraOptions = [
        "--network=macvlan_lan"
        "--ip=${secrets.ip.frigate}"
        "--pull=always" # always want a good pull
        "--privileged"
        "--shm-size=256m" # 64m was too low
        "--device=/dev/apex_0:/dev/apex_0" # coral
        "--device=/dev/dri/renderD128" # gpu
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000" # tempfs
      ];
    };
  };
  # write file, symlink to dir via home-manager <3
  # changes to this post-rebuild will require frigate to be restarted
  home-manager.users.${spaghetti.user}.home.file.".containers/${hostName}/config/config.yml".text = ''
    cameras:
    #
      driveway:
        best_image_timeout: 60
        ffmpeg:
          inputs:
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
          - rtsp://${secrets.user.drivecam}:${secrets.password.drivecam}@${secrets.ip.drivecam}:554/h264Preview_01_main
        entry:
          - rtsp://${secrets.user.entrycam}:${secrets.password.entrycam}@${secrets.ip.entrycam}:554/h264Preview_01_main
    #
    logger:
      default: info
      logs:
        peewee: info
        ws4py: info
    #
    motion:
      threshold: 90
    #
    mqtt:
      client_id: ${secrets.user.frigate}
      enabled: false
      host: ${secrets.ip.mqtt}
      password: ${secrets.password.mqtt}
      port: 1883
      stats_interval: 60
      topic_prefix: frigate
      user: ${secrets.user.frigate}
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
    #detectors:
    #   deepstack:
    #     api_url: http://${secrets.ip.codeproject}:32168/v1/vision/detection
    #     type: deepstack
    #     api_timeout: 1 # seconds
    #
    # using onboard coral v
    detectors:
      coral_pci:
        type: edgetpu
        device: pci
    #
    birdseye:
      enabled: true
      width: 640
      height: 480
    #
  '';
}
