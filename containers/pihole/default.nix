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
    # looks to make directories on boot / rebuild - not sure if docker will handle this by itself?
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

      # extraOptions = ["-h=pihole"];
      # environment = {WEBPASSWORD = "fcXC2zkU5y8zvRuFugb9k9zOoIbwkkCEXOsxdvCCwNFd3IomyLBFIVfiLz4j";};
    };
  }
# yoinked from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads
# added my own tweaks

