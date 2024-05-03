let
  hostName = "pihole";
in
  {
    spaghetti,
    config,
    pkgs,
    lib,
    ...
  }: {
    networking.firewall.allowedTCPPorts = [533 8080];
    networking.firewall.allowedUDPPorts = [533 57 67];

    virtualisation.oci-containers.containers."${hostName}" = {
      autoStart = true;
      image = "pihole/pihole:latest";
      ports = [
        # "host:container"
        "533:53/udp"
        "533:53/tcp"
        "67:67/udp"
        "8080:80/tcp"
      ];
      volumes = [
        "/home/${spaghetti.user}/.containers/${hostName}/etc:/etc/pihole"
        "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d:/etc/dnsmasq.d"
      ];
      extraOptions = ["--cap-add=net_admin"];
    };
  }
# yoinked from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads
# added my own tweaks

