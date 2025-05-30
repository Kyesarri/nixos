{
  secrets,
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../containers

    # all containers below have static configs
    ../../containers/emqx
    ../../containers/esphome
    ../../containers/frigate
    ../../containers/homer
    ../../containers/orcaslicer
    ../../containers/mailu
    # ../../containers/overseerr
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  cont = {
    arr.enable = true;
    changedetection.enable = true;
    cloudflared.enable = true; # todo mkoption string for multiple hosts
    cpai.enable = true;
    doubletake.enable = true;
    headscale.enable = false;
    haos.enable = true;
    i2p.enable = true;
    ztnet.enable = true;
    radicale.enable = true;
    rocket-chat.enable = true;
    static-web.enable = true;
    syncthing.enable = true;
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
    backend-network = {
      enable = true;
      subnet = "${secrets.vlan.erying.subnet}";
      range = "${secrets.vlan.erying.range}";
      mask = "${secrets.vlan.erying.mask}";
    };
    #
    dms = {
      # start-mailserver.sh: You need at least one mail account to start Dovecot (120s left for account creation before shutdown)
      enable = false;
      fqdn = "${secrets.domain.fqdn}";
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
    #
    nginx-wan = {
      enable = true;
      autoStart = true;
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
    tvheadend = {
      enable = true;
      macvlanIp = "${secrets.ip.tvheadend}";
    };
    #
    webdav = {
      enable = true;
      userName = "${secrets.user.webdav}";
      password = "${secrets.password.webdav}";
      vlanIp = "${secrets.vlan.erying.webdav}";
    };
    #
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
  # this shit is yuck
  systemd.services."create-podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-adguard-${config.networking.hostName}.service"
      "podman-emqx.service"
      "podman-esphome.service"
      "podman-frigate.service"
      "podman-ghost.service"
      "podman-ghost-db.service"
      "podman-haos-${config.networking.hostName}.service"
      "podman-homer.service"
      "podman-matter.service"
      "podman-nginx-lan-${config.networking.hostName}.service"
      "podman-nginx-wan-${config.networking.hostName}.service"
      "podman-orcaslicer.service"
      "podman-radicale-${config.networking.hostName}.service"
      "podman-syncthing.service"
      "podman-tailscale-${config.networking.hostName}-subnet.service"
      "podman-webdav-${config.networking.hostName}.service"
      "podman-zigbee2mqtt-${config.networking.hostName}.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || \
        podman network create --driver macvlan --opt parent=eth0 --subnet ${toString secrets.ip.subnet}/24 --ip-range ${toString secrets.ip.range}/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
