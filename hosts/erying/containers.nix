# this module configures which containers our host will be running
# along with our macvlan (containers get their own ip / mac on our lan vs using ports on the host)
{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/cpai
    ../../containers/doubletake
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/frigate
    ../../containers/fweedee
    ../../containers/ghost
    ../../containers/homer
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

  # container module config
  cont = {
    backend-network = {
      enable = true; # probably want this on
      subnet = "${secrets.vlan.erying.subnet}";
      range = "${secrets.vlan.erying.range}";
      mask = "${secrets.vlan.erying.mask}";
    };
    adguard = {
      enable = true;
      ipAddr = "${secrets.ip.adguard-erying}";
      image = "adguard/adguardhome:latest";
      contName = "erying-adguard";
      timeZone = "Australia/Melbourne";
    };
    tailscale = {
      enable = true;
      ipAddr = "${secrets.ip.tailscale-erying}";
      image = "tailscale/tailscale:latest";
      subnet = "${secrets.ip.subnet}";
      contName = "tailscale-${config.networking.hostName}-subnet";
      timeZone = "Australia/Melbourne";
    };
  };

  # macvlan config
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
      "podman-tailscale-${config.networking.hostName}-subnet.service"
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
