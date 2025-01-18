{pkgs, ...}: {
  imports = [
    ./adguard
    ./backend-network
    ./dms
    ./haos
    ./headscale
    ./nginx-lan
    ./nginx-wan
    ./radicale
    ./tailscale
    ./zigbee2mqtt
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      extraPackages = [pkgs.zfs];
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  environment.systemPackages = with pkgs; [
    podman # the boi
    podman-tui # nice tui interface
    intel-gpu-tools # intel igpu monitor - used for plex / frigate igpu use monitoring
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in) for another #TODO jellyfin
  ];
}
