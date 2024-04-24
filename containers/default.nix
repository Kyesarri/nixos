{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./authelia # nsp
    # ./blocky # nsp
    # ./codeproject # oci
    ./frigate # oci
    ./home-assistant # oci
    # ./nextcloud # nsp
    ./nginx-proxy-manager # oci
    ./plex # oci
  ];

  virtualisation = {
    oci-containers.backend = "podman"; # set podman as our default backend for containers
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true; # lets us use docker commands - translate to podman
    };
  };
  /*
  # https://madison-technologies.com/take-your-nixos-container-config-and-shove-it/
  # we create a systemd service so that we can create a single "pod"
  # for our containers to live inside of. This will mimic how docker compose
  # creates one network for the containers to live inside of
  systemd.services.create-pod-network = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = ["${backend}-nginx-proxy-manager.service" "${backend}-frigate.service" "${backend}-home-assistant.service" "${backend}-plex.service"];
    script = ''
      ${pkgs.podman}/bin/podman network exists pod-net || \
      ${pkgs.podman}/bin/podman network create pod-net
    '';
  };
  */

  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools # useful for monitoring igpu usage
  ];
}
