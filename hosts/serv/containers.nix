{
  pkgs,
  config,
  secrets,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/home-assistant
  ];

  virtualisation = {
    oci-containers.backend = "podman";
    podman = {
      enable = true;
      extraPackages = [pkgs.zfs];
      autoPrune.enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  cont = {
    # nzbget will be a pain as multi machines will cause me greif / podman networking :)
    nzbget.enable = false;
    syncthing.enable = false;
    pinchflat.enable = true;

    #
    backend-network = {
      enable = true;
      subnet = "${secrets.vlan.serv.subnet}";
      range = "${secrets.vlan.serv.range}";
      mask = "${secrets.vlan.serv.mask}";
    };
    #
    adguard = {
      enable = true;
      macvlanIp = "${secrets.ip.adguard-serv}";
      vlanIp = "${secrets.vlan.serv.adguard}";
      image = "adguard/adguardhome:latest";
      contName = "adguard-${config.networking.hostName}";
      timeZone = "Australia/Melbourne";
    };
    #
    immich = {
      enable = true;
      privateNetwork = false;
      macvlanDev = "";
    };
    #
    plex = {
      enable = true;
      macvlanIp = "${secrets.ip.plex}";
      vlanIp = "${secrets.vlan.serv.plex}";
    };
    #
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
      "podman-adguard-${config.networking.hostName}.service"
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
