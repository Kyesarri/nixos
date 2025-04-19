{pkgs, ...}: {
  imports = [
    ./adguard # dns + dhcp + adblock
    ./arr # arr stack
    ./backend-network # backend network - for inter container comms not on main lan
    ./cpai
    ./doubletake
    ./dms # todo
    ./haos # home assistant, cloud free home automation
    ./headscale # testing ground for tailscale replacement - vpn for remote connections to lan
    ./immich # self-hosted image server
    ./jellyfin # opensource media server / streamer
    ./nginx-lan # reverse proxy for local services
    ./nginx-wan # reverse proxy for webhosting
    ./nzbget # nzb client
    ./plex
    ./radicale # calendar + todo thingy
    ./restreamer # camera restream utility - use for 3d printer?
    ./subgen # ai subtitle generator thingy
    ./subsai # ai subtitle generator thingy
    ./tailscale # vpn for remote connections to lan
    ./tvheadend # testing - want to try re-streaming via plex
    ./webdav # basic webdav server, based on nginx
    ./zigbee2mqtt # home automation thingy, lights, sensors, the good stuff
    ./ztnet # testing - ztnet container lots going on here is WIP
  ];

  systemd.targets."podman-internal-root" = {
    unitConfig = {Description = "internal network root target";};
    wantedBy = ["multi-user.target"];
  };

  systemd.services."podman-network-internal" = {
    script = ''podman network inspect internal || podman network create internal'';
    partOf = ["podman-internal-root.target"];
    wantedBy = ["podman-internal-root.target"];
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f internal";
    };
  };
  # from compose2nix:
  # Enable container name DNS for non-default Podman networks.
  # https://github.com/NixOS/nixpkgs/issues/226365
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53];

  environment.systemPackages = with pkgs; [
    podman # the boi
    podman-tui # nice tui interface for podman
    intel-gpu-tools # intel igpu monitor - used for plex / frigate igpu use monitoring
    intel-compute-runtime # openCL filter support (hardware tonemapping and subtitle burn-in) for another #TODO jellyfin
  ];
}
