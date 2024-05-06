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
    description = "Start podman 'pod-net' pod";
    wants = ["network-online.target"];
    after = ["network-online.target"];
    requiredBy = ["podman-frigate.service"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "-${pkgs.podman}/bin/podman pod create --driver=macvlan --gateway=192.168.87.251 --subnet=192.168.87.0/24 -o parent=enp1s0 pod-net";
    };
  };
}
