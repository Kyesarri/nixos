{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "pihole";
  webPort = 8080;
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -p ${toString dir1} ${toString dir2}
  '';

  networking.firewall.allowedTCPPorts = [53 webPort];
  networking.firewall.allowedUDPPorts = [53 67 webPort];

  virtualisation.oci-containers.containers."${hostName}" = {
    hostname = "${hostName}";
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [
      "53:53/udp"
      "53:53/tcp"
      "67:67/udp"
      "${toString webPort}:80/tcp"
    ];
    volumes = [
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];
    extraOptions = ["--cap-add=net_admin"];
  };
}
# yoinked base config from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads

