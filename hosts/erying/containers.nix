{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers
    # ../../containers/authelia
    # ../../containers/uptime-kuma
    ../../containers/frigate
    # ../../containers/pihole
  ];

  systemd.services.create-pod-net = {
    description = "Start podman 'burrow' pod";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    wantedBy = ["podman-frigate.service"];
    serviceConfig.Type = "oneshot";
    #ExecStart = "-${pkgs.podman}/bin/podman pod create --driver=macvlan --gateway=192.168.87.251 --subnet=192.168.87.0/24 -o parent=enp3s0 burrow";

    script = ''
      ${pkgs.podman}/bin/podman network exists burrow || \
        ${pkgs.podman}/bin/podman network create --driver=macvlan --gateway=192.168.87.251 --subnet=192.168.87.0/24 -o parent=enp3s0 burrow
    '';
  };
}
