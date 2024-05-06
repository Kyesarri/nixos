{config, ...}: {
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
      ExecStart = "-${pkgs.podman}/bin/podman pod create pod-net";
    };
  };
}
