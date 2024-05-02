let
  hostName = "pihole";
in
  {
    config,
    pkgs,
    lib,
    spaghetti,
    ...
  }: {
    # looks to make directories on boot / rebuild - not sure if podman will handle this by itself?
    # don't believe so, this is quite handy xoxo
    system.activationScripts.makePiHoleDir = lib.stringAfter ["var"] ''
      mkdir -p /home/${spaghetti.user}/.docker/${hostName}/etc /home/${spaghetti.user}/.docker/${hostName}/etc/dnsmasq.d
    '';

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
        "/home/${spaghetti.user}/.docker/${hostName}/etc:/etc/pihole"
        "/home/${spaghetti.user}/.docker/${hostName}/etc/dnsmasq.d:/etc/dnsmasq.d"
      ];
      extraOptions = ["--cap-add=net_admin"];
    };
  }
# yoinked from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads
# added my own tweaks

