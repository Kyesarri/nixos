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
    ../../containers/pihole
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-frigate.service"
      "podman-pihole.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=enp3s0 --subnet 192.168.87.0/24 --ip-range 192.168.87.255/24 --gateway 192.168.87.251 --disable-dns=false macvlan_lan
    '';
  };
}
