# this module configures which containers our host will be running
# along with our macvlan (containers get their own ip address vs using ports from the host)
{
  secrets,
  pkgs,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/adguard
    ../../containers/cpai
    ../../containers/doubletake
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/frigate
    ../../containers/homer
    ../../containers/homer-wan
    ../../containers/matter
    ../../containers/minecraft
    ../../containers/nginx-proxy-manager
    ../../containers/nginx-proxy-manager-2 # change to nginx-wan "soon"
    ../../containers/octoprint
    ../../containers/orcaslicer
    ../../containers/overseerr
    # ../../containers/peanut
    # ../../containers/netbird # this wont work out the box :D
    ../../containers/syncthing # testing 25.09.24
    ../../containers/ustreamer
    # ../../containers/zitadel
    # ../../containers/uptime-kuma
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-adguard.service"
      "podman-cpai.service"
      "podman-doubletake.service"
      "podman-emqx.service"
      "podman-esphome.service"
      "podman-frigate.service"
      "podman-homer.service"
      "podman-homer-wan.service"
      "podman-matter.service"
      "podman-minecraft.service"
      "podman-nginx-proxy-manager.service"
      "podman-nginx-proxy-manager-2.service"
      "podman-octoprint.service"
      "podman-overseerr.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=enp4s0 --subnet 192.168.87.0/24 --ip-range 192.168.87.255/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
