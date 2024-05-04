{
  spaghetti,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "pihole";
  webPort = 32168;
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d:";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -p ${toString dir1} ${toString dir2} && echo volumes created for ${hostName}
  '';

  networking.firewall.allowedTCPPorts = [53 8080];
  networking.firewall.allowedUDPPorts = [53 67];

  virtualisation.oci-containers.containers."${hostName}" = {
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [
      # "host:container"
      "53:53/udp"
      "53:53/tcp"
      "67:67/udp"
      "8080:80/tcp"
    ];
    volumes = [
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];
    extraOptions = ["--cap-add=net_admin"];
  };
}
# yoinked from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads
# added my own tweaks

