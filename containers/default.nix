{pkgs, ...}: {
  imports = [
    ./adguard # dns + dhcp + adblock
    ./backend-network # backend network - for inter container comms not on main lan
    ./dms # todo
    ./haos # home assistant, cloud free home automation
    ./headscale # testing ground for tailscale replacement - vpn for remote connections to lan
    ./immich # self-hosted image server
    ./jellyfin # opensource media server / streamer
    ./nginx-lan # reverse proxy for local services
    ./nginx-wan # reverse proxy for webhosting
    ./nzbget # nzb client
    ./radicale # calendar + todo thingy
    ./restreamer # camera restream utility - use for 3d printer?
    ./subgen # ai subtitle generator thingy
    ./subsai # ai subtitle generator thingy
    ./tailscale # vpn for remote connections to lan
    ./webdav # basic webdav server, based on nginx
    ./zigbee2mqtt # home automation thingy, lights, sensors, the good stuff
  ];

  environment.systemPackages = with pkgs; [
    podman # the boi
    podman-tui # nice tui interface for podman
    intel-gpu-tools # intel igpu monitor - used for plex / frigate igpu use monitoring
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in) for another #TODO jellyfin
  ];
}
