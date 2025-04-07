{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [../../containers];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  # trying to keep naming to "service-host-name*-feature*" ex - tailscale-nix-erying-subnet - haos-nix-erying
  cont = {};

  # macvlan config
  systemd.services."create-podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || \
        podman network create --driver macvlan --opt parent=eno1 --subnet ${toString secrets.ip.subnet}/24 --ip-range ${toString secrets.ip.range}/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
