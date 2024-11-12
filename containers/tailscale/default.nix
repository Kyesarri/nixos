{
  secrets,
  lib,
  ...
}: let
  contName = "tailscale";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}'';

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "tailscale/tailscale:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/var/lib/tailscale"
      "/dev/net/tun:/dev/net/tun"
    ];
    cmd = [
      # "--advertise-tags=tag:container"
    ];
    environment = {
      TZ = "Australia/Melbourne";
      PUID = "1000";
      PGID = "1000";
      TS_AUTHKEY = "${secrets.password.tailscale}";
      TS_EXTRA_ARGS = "--advertise-tags=tag:container";
      # TS_STATE_DIR = "/var/lib/tailscale";
      # TS_USERSPACE = false;
    };

    extraOptions = [
      "--network=macvlan_lan:ip=${secrets.ip.tailscale}"
      "--privileged"
    ];
  };
}
