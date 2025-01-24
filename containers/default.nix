{pkgs, ...}: {
  imports = [
    ./adguard # dns + dhcp + adblock
    ./backend-network # backend network - for inter container comms not on main lan
    ./dms # todo
    ./haos # home assistant, cloud free home automation
    ./headscale # testing ground for tailscale replacement - vpn for remote connections to lan
    ./nginx-lan # reverse proxy for local services
    ./nginx-wan # reverse proxy for webhosting
    ./radicale # calendar + todo thingy
    ./subsai # ai subtitle thingy
    ./tailscale # vpn for remote connections to lan
    ./zigbee2mqtt # home automation thingy, lights, sensors, the good stuff
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
    podman-tui # nice tui interface for podman
    intel-gpu-tools # intel igpu monitor - used for plex / frigate igpu use monitoring
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in) for another #TODO jellyfin
  ];
}
