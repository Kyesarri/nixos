{
  pkgs,
  config,
  secrets,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/home-assistant
    ../../containers/plex
    ../../containers/immich
  ];

  cont = {
    backend-network = {
      enable = true; # probably want this on
      subnet = "${secrets.vlan.serv.subnet}";
      range = "${secrets.vlan.serv.range}";
      mask = "${secrets.vlan.serv.mask}";
    };

    adguard = {
      enable = true;
      macvlanIp = "${secrets.ip.adguard-serv}";
      vlanIp = "${secrets.vlan.serv.adguard}";
      image = "adguard/adguardhome:latest";
      contName = "serv-adguard";
      timeZone = "Australia/Melbourne";
    };

    tailscale = {
      enable = true;
      macvlanIp = "${secrets.ip.tailscale-serv}";
      vlanIp = "${secrets.vlan.serv.tailscale}";
      vlanSubnet = "${secrets.vlan.serv.subnet}";
      image = "tailscale/tailscale:latest";
      subnet = "${secrets.ip.subnet}";
      contName = "tailscale-${config.networking.hostName}-subnet";
      authKey = "${secrets.password.tailscale}";
    };
  };

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-home-assistant.service"
      "podman-plex.service"
      "podman-tailscale-${config.networking.hostName}-subnet.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=eno1 --subnet ${toString secrets.ip.subnet}/24 --ip-range ${toString secrets.ip.range}/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
