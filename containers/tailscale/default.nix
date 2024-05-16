{lib, ...}: let
  contName = "tailscale";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "tailscale/tailscale:stable";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}/tailscale:/var/lib/tailscale"
      "${toString dir1}/config:/config"
      "/dev/net/tun:/dev/net/tun"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
      TS_HOSTNAME = "${contName}";
      TS_STATE_DIR = "/var/lib/tailscale";
    };

    extraOptions = [
      "--cap-add=NET_ADMIN"
      "--cap-add=NET_RAW"
      "--network=macvlan_lan"
      "--ip=192.168.87.40"
    ];
  };
}
