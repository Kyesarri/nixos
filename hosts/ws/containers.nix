{
  pkgs,
  config,
  secrets,
  ...
}: {
  imports = [
    ../../containers
  ];

  cont = {
    #TODO add containers here
  };

  systemd.services."podman-network-macvlan_lan" = {
    path = [pkgs.podman];
    wantedBy = [
      #TODO add containers here
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
