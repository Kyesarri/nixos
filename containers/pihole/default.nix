{
  secrets,
  lib,
  ...
}: let
  contName = "pihole";
  dir1 = "/etc/oci.cont/${contName}/etc/pihole";
  dir2 = "/etc/oci.cont/${contName}/etc/dnsmasq.d";
  # dir1 = "/home/${spaghetti.user}/.containers/${contName}/etc/pihole";
  # dir2 = "/home/${spaghetti.user}/.containers/${contName}/etc/dnsmasq.d";
in {
  system.activationScripts.makePiHoleDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "pihole/pihole:latest";
    ports = [];

    environment = {
      TZ = "Australia/Melbourne";
      DNS1 = "1.1.1.1";
      DNS2 = "1.0.0.1";
      # FTLCONF_LOCAL_IPV4 = "${secrets.ip.pihole}";
      # DHCP_ACTIVE = "true";
      # DHCP_START = "";
      # DHCP_END = "";
      # DHCP_ROUTER = "${secrets.ip.gateway}";
    };

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/pihole"
      "${toString dir2}:/etc/dnsmasq.d"
    ];

    extraOptions = [
      "--pull=always"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.pihole}"
      "--restart=unless-stopped"
      "--dns=127.0.0.1"
    ];
  };
}
# yoinked base config from https://gitlab.com/yramagicman/stow-dotfiles/-/blob/master/nixos/browncoat/pihole.nix?ref_type=heads

