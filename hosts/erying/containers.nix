{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers

    # all containers below have static configs
    ../../containers/cpai
    ../../containers/doubletake
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/frigate
    # ../../containers/fweedee # running on pi 3a+ now
    ../../containers/ghost
    ../../containers/homer
    ../../containers/i2pd
    ../../containers/matter
    # ../../containers/octoprint # running on pi 3a+ now
    ../../containers/orcaslicer
    ../../containers/overseerr
    # ../../containers/netbird # this wont work out the box :D
    ../../containers/syncthing
    # ../../containers/zitadel
  ];

  # trying to keep naming to "service-host-name*-feature*" ex - tailscale-nix-erying-subnet - haos-nix-erying

  cont = {
    backend-network = {
      enable = true;
      subnet = "${secrets.vlan.erying.subnet}";
      range = "${secrets.vlan.erying.range}";
      mask = "${secrets.vlan.erying.mask}";
    };
    #
    haos = {
      enable = true;
      autoStart = true;
      macvlanIp = "${secrets.ip.haos-erying}";
      vlanIp = "${secrets.vlan.erying.haos}";
      image = "ghcr.io/home-assistant/home-assistant:beta";
      contName = "haos-${config.networking.hostName}";
    };
    headscale = {
      enable = true;
      macvlanIp = "${secrets.ip.headscale}";
      derp = {
        enable = false;
      };
      ui = {
        enable = false;
      };
    };
    #
    adguard = {
      enable = true;
      macvlanIp = "${secrets.ip.adguard-erying}";
      vlanIp = "${secrets.vlan.erying.adguard}";
      image = "adguard/adguardhome:latest";
      contName = "adguard-${config.networking.hostName}";
      timeZone = "Australia/Melbourne";
    };
    #
    nginx-lan = {
      enable = true;
      macvlanIp = "${secrets.ip.nginx-lan}";
      vlanIp = "${secrets.vlan.erying.nginx-lan}";
      image = "docker.io/jc21/nginx-proxy-manager:latest";
      contName = "nginx-lan-${config.networking.hostName}";
      timeZone = "Australia/Melbourne";
    };
    nginx-wan = {
      enable = true;
      macvlanIp = "${secrets.ip.nginx-wan}";
    };
    #
    tailscale = {
      enable = true;
      macvlanIp = "${secrets.ip.tailscale-erying}";
      vlanIp = "${secrets.vlan.erying.tailscale}";
      vlanSubnet = "${secrets.vlan.erying.subnet}";
      image = "tailscale/tailscale:latest";
      subnet = "${secrets.ip.subnet}";
      contName = "tailscale-${config.networking.hostName}-subnet";
      timeZone = "Australia/Melbourne";
      authKey = "${secrets.password.tailscale}";
    };
    zigbee2mqtt = {
      enable = true;
      macvlanIp = "${secrets.ip.zigbee2mqtt}";
      # vlanIp = "${secrets.vlan.erying.zigbee2mqtt}";
      mqtt = {
        serial = "tcp://${secrets.ip.SLZB-06P7}:6638";
        server = "mqtt://${secrets.ip.emqx}:1883";
        user = "${secrets.user.zigbee2mqtt-emqx}";
        password = "${secrets.password.zigbee2mqtt-emqx}";
      };
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
      "podman-ghost.service"
      "podman-ghost-db.service"
      "podman-haos-${config.networking.hostName}.service"
      "podman-headscale-${config.networking.hostName}.service"
      "podman-homer.service"
      "podman-homer-wan.service"
      "podman-matter.service"
      "podman-nginx-lan-${config.networking.hostName}.service"
      "podman-nginx-wan-${config.networking.hostName}.service"
      "podman-orcaslicer.service"
      "podman-overseerr.service"
      "podman-syncthing.service"
      "podman-tailscale-${config.networking.hostName}-subnet.service"
      "podman-zigbee2mqtt-${config.networking.hostName}.service"
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
