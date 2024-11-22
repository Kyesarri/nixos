{
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/home-assistant
    ../../containers/plex
    ../../containers/immich
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-home-assistant.service"
      "podman-plex.service"
      "podman-serv-tailscale-subnet.service"
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

  cont = {
    tailscale = {
      enable = true;
      ipAddr = "${secrets.ip.tailscale-serv}";
      subnet = "${secrets.ip.subnet}";
      contName = "serv-tailscale-subnet";
      # authKey = "${secrets.password.tailscale}";
    };
  };
}
