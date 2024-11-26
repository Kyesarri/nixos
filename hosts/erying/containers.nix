{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers # containers imported here have config defined under cont = {
    #
    # all containers below have static configs
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
    ../../containers/nginx-proxy-manager-2 # change to nginx-wan "soon"
    ../../containers/octoprint
    ../../containers/orcaslicer
    ../../containers/overseerr
    # ../../containers/netbird # this wont work out the box :D
    ../../containers/syncthing
    # ../../containers/zitadel
  ];

  # as i stagger through configuring modules this will probably see more changes
  # options like timezone / image are added here but not required due to defaults being configured
  #
  # trying to keep naming to "service-host-name*-feature*" ex - tailscale-nix-erying-subnet

  cont = {
    backend-network = {
      enable = true; # want this on as containers are starting to use the backend network - dns not working here yet fml :)
      subnet = "${secrets.vlan.erying.subnet}"; # subnet ex - 10.0.0.0
      range = "${secrets.vlan.erying.range}"; # range ex - 10.0.0.255
      mask = "${secrets.vlan.erying.mask}"; # mask ex - 24 - don't add /
    };
    #
    adguard = {
      enable = true;
      ipAddr = "${secrets.ip.adguard-erying}";
      vlanIp = "${secrets.vlan.erying.nginx-lan}";
      image = "adguard/adguardhome:latest";
      contName = "adguard-${config.networking.hostName}";
      timeZone = "Australia/Melbourne";
    };
    #
    nginx-lan = {
      enable = true;
      macvlanIp = "${secrets.ip.nginx-lan}"; # rename this to macvlanIp?
      vlanIp = "${secrets.vlan.erying.nginx-lan}";
      image = "docker.io/jc21/nginx-proxy-manager:latest"; # container image
      contName = "nginx-lan-${config.networking.hostName}"; # podman-nginx-lan-nix-erying also used for container volume directory names
      timeZone = "Australia/Melbourne";
    };
    #
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
      "podman-adguard-${config.networking.hostName}.service"
      "podman-cpai.service"
      "podman-doubletake.service"
      "podman-emqx.service"
      "podman-esphome.service"
      "podman-frigate.service"
      "podman-homer.service"
      "podman-homer-wan.service"
      "podman-matter.service"
      "podman-nginx-lan-${config.networking.hostName}.service"
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
      podman network exists macvlan_lan || \
        podman network create --driver macvlan --opt parent=enp4s0 --subnet ${toString secrets.ip.subnet}/24 --ip-range ${toString secrets.ip.range}/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
