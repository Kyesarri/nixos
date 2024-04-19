# yoinked from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads
{
  config,
  pkgs,
  lib,
  spaghetti,
  ...
}: {
  system.activationScripts.makeRediaryDir = lib.stringAfter ["var"] ''
    mkdir -p /home/${spaghetti.user}/.docker/pihole/etc /home/${spaghetti.user}/.docker/pihole/etc/dnsmasq.d
  '';
  virtualisation.oci-containers = {
    containers = {
      "pihole" = {
        autoStart = true;
        image = "pihole/pihole:latest";

        ports = [
          "53:53/udp"
          "53:53/tcp"
          "8080:80/tcp"
        ];
        volumes = [
          "/home/${spaghetti.user}/.docker/pihole/etc:/etc/pihole"
          "/home/${spaghetti.user}/.docker/pihole/etc/dnsmasq.d:/etc/dnsmasq.d"
        ];

        extraOptions = ["-h=pihole"];
        environment = {
          # WEBPASSWORD = "fcXC2zkU5y8zvRuFugb9k9zOoIbwkkCEXOsxdvCCwNFd3IomyLBFIVfiLz4j";
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    53
    8080
  ];

  networking.firewall.allowedUDPPorts = [
    53
    8080
  ];
}
