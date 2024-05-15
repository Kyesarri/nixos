{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers
    # ../../containers/authelia
    ../../containers/emqx
    # ../../containers/esphome
    ../../containers/homer
    ../../containers/haos
    ../../containers/frigate
    ../../containers/nginx-proxy-manager
    ../../containers/pihole
    # ../../containers/uptime-kuma
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-emqx.service"
      "podman-homer.service"
      "podman-haos.service"
      "podman-frigate.service"
      "podman-nginx-proxy-manager.service"
      "podman-pihole.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=enp3s0 --subnet 192.168.87.0/24 --ip-range 192.168.87.255/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
