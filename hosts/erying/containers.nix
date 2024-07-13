{
  secrets,
  pkgs,
  ...
}: {
  imports = [
    ../../containers # will  be the only module required once serv is depreciated
    # ../../containers/arr # temp
    ../../containers/adguard
    ../../containers/cpai
    ../../containers/doubletake
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/homer
    ../../containers/haos
    ../../containers/frigate
    ../../containers/nginx-proxy-manager
    ../../containers/zigbee2mqtt

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
