# this module configures which containers our host will be running
# along with our macvlan (containers get their own ip / mac on our lan vs using ports on the host)
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
    ../../containers/fweedee
    ../../containers/ghost
    ../../containers/homer
    ../../containers/homer-wan
    ../../containers/i2pd
    ../../containers/matter
    ../../containers/nginx-proxy-manager
    ../../containers/nginx-proxy-manager-2 # change to nginx-wan "soon"
    ../../containers/octoprint
    ../../containers/orcaslicer
    ../../containers/overseerr
    # ../../containers/netbird # this wont work out the box :D
    ../../containers/syncthing
    # ../../containers/zitadel
  ];

  systemd.services."create-podman-network-macvlan_lan" = {
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
      "podman-nginx-proxy-manager.service"
      "podman-nginx-proxy-manager-2.service"
      "podman-octoprint.service"
      "podman-orcaslicer.service"
      "podman-overseerr.service"
      "podman-syncthing.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=enp4s0 --subnet ${toString secrets.ip.subnet}/24 --ip-range ${toString secrets.ip.range}/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
