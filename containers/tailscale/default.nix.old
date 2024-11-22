# simple tailscale subnet router - allows remote access to internal LAN
# wont work OOB - need to add your own ts_authkey
{
  secrets,
  config,
  lib,
  ...
}: let
  contName = "tailscale";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers."${contName}-subnet" = {
    hostname = "${contName}";

    autoStart = true;

    image = "tailscale/tailscale:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/var/lib/tailscale"
      "/dev/net/tun:/dev/net/tun"
    ];

    cmd = [];

    environment = {
      TZ = "Australia/Melbourne";
      TS_HOSTNAME = "${config.networking.hostName}-${contName}-subnet";
      TS_AUTHKEY = "${secrets.password.tailscale}";
      PUID = "1000";
      PGID = "1000";
      TS_EXTRA_ARGS = "--advertise-tags=tag:container --advertise-routes=${secrets.ip.subnet}/24";
      TS_STATE_DIR = "/var/lib/tailscale";
    };

    extraOptions = [
      "--network=macvlan_lan:ip=${secrets.ip.tailscale}" # wont work for multiple machines with this value
      "--privileged"
    ];
  };
}
