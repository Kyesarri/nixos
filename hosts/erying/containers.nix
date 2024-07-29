# this module configures which containers our host will be running
# along with our macvlan (containers get their own ip address vs using ports from the host)
{
  secrets,
  pkgs,
  ...
}: {
  imports = [
    ../../containers # will be the only module required once serv is depreciated, not sure this will go to plan yet
    # ../../containers/arr # temp
    ../../containers/adguard
    ../../containers/cpai
    ../../containers/doubletake
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/frigate
    ../../containers/homer
    # ../../containers/haos # needs configs, complete barebones
    ../../containers/matter
    ../../containers/minecraft
    ../../containers/nginx-proxy-manager
    ../../containers/nginx-proxy-manager-2
    ../../containers/zigbee2mqtt
    ../../containers/overseerr
    # ../../containers/uptime-kuma
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-adguard.service"
      "podman-cpai.service"
      "podman-doubletake.service"
      "podman-emqx.service"
      "podman-emqx.service"
      "podman-esphome.service"
      "podman-frigate.service"
      "podman-homer.service"
      # "podman-haos.service"
      "podman-matter.service"
      "podman-nginx-proxy-manager.service"
      "podman-zigbee2mqtt.service"
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
