{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  hostName = "pihole";
  dir1 = "/home/${spaghetti.user}/.containers/${hostName}/etc/pihole";
  dir2 = "/home/${spaghetti.user}/.containers/${hostName}/etc/dnsmasq.d";
in {
  system.activationScripts.makePiHoleDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2}
  '';

  virtualisation.oci-containers.containers."${hostName}" = {
    hostname = "${hostName}-nix-erying";
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [
      #"53:53/udp"
      #"53:53/tcp"
      #"67:67/udp"
      #"80:80/tcp"
    ];

    environment = {
      TZ = "Australia/Melbourne";
      DNS1 = "1.1.1.1";
      DNS2 = "8.8.8.8";
      FTLCONF_LOCAL_IPV4 = "192.168.87.1";
      #FTLCONF_LOCAL_IPV6 = "fd00::52e6:36ff:6496:f0f6";
      #WEBPASSWORD = "nixpihole";
    };
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];

    extraOptions = [
      "--network=macvlan_lan"
      # "--ip=${secrets.ip.pihole}"
      "--pull=always"
      "--privileged"
      # "--FTLCONF_LOCAL_IPV4=${secrets.ip.pihole}"
      # "--dns=127.0.0.1"
    ];
  };
}
# yoinked base config from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads

