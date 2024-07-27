{
  pkgs,
  secrets,
  ...
}: {
  imports = [
    ../../containers
    ../../containers/home-assistant # oci
    ../../containers/plex # oci
    ../../containers/hsd
  ];

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      "podman-home-assistant.service"
      "podman-plex.service"
    ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f macvlan_lan";
    };
    script = ''
      podman network exists macvlan_lan || podman network create --driver macvlan --opt parent=eno1 --subnet 192.168.87.0/24 --ip-range 192.168.87.255/24 --gateway ${toString secrets.ip.gateway} --disable-dns=false macvlan_lan
    '';
  };
}
