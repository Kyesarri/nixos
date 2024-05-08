{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "pihole";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/pihole";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d";
in {
  system.activationScripts.makePiHoleDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2}
  '';

  virtualisation.oci-containers.containers."${hostName}" = {
    hostname = "${hostName}-nix-erying";
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [
      #"53:53/udp"
      #"53:53/tcp"
      "67:67/udp"
      "80:80/tcp"
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.pihole}"
      "--pull=always" # always want a good pull
      "--privileged"
    ];
  };
}
# yoinked base config from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads

