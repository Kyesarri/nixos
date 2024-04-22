{
  config,
  pkgs,
  ...
}: {
  imports = [
    # ./authelia
    ./blocky
    # ./codeproject
    ./frigate
    ./home-assistant
    # ./nextcloud
    ./nginx-proxy-manager
    ./plex
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman
    podman-tui
    intel-gpu-tools
  ];
}
