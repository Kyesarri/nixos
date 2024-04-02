{
  spaghetti,
  config,
  lib,
  pkgs,
  ...
}: {
  virtualisation.oci-containers.containers.frigate = {
    backend = "docker"; # or podman
    hostname = "frigate";
    autoStart = true;
    image = "blakeblackshear/frigate:stable"; # or ghcr.io/blakeblackshear/frigate:stable
    ports = [
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
}
