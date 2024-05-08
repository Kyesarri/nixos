{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "pihole";
  web = 8080;
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/pihole";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d";
in {
  system.activationScripts.makePiHoleDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2}
  '';

  networking.firewall.allowedTCPPorts = [53 web];
  networking.firewall.allowedUDPPorts = [53 67 web];

  virtualisation.oci-containers.containers."${hostName}" = {
    hostname = "${hostName}-nix-erying";
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [
      # "53:53/udp"
      # "53:53/tcp"
      # "67:67/udp"
      "${toString web}:80/tcp"
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];

    extraOptions = [
      "--pull=always" # always want a good pull
      "--network=macvlan_lan"
      "--privileged"
      "--ip=${secrets.ip.pihole}"
    ];
  };
}
# yoinked base config from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads

