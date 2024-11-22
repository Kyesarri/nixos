{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.tailscale;
in {
  #
  # few things assumed here - containers storage is mounted in /etc/oci.cont/contName - dirs will be created
  # we're using a macvlan configuration with the name macvlan_lan
  # containers are tested under podman - will probably work fine under docker
  # container will receive a tag "containers" in tailscale
  # will by default publish subnets
  #
  options.cont.tailscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable tailscale subnet container";
    };
    ipAddr = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "set containers ip address";
    };
    subnet = mkOption {
      type = types.str;
      default = "10.10.0.0";
      example = "10.10.10.0";
      description = "set containers ip address";
    };
    contName = {
      type = types.str;
      default = "tailscale-${config.networking.hostName}-subnet";
      example = "my-fabulous-subnet-router";
      description = "container name";
    };
    authKey = {
      type = types.anything;
      default = "yernarnaryer";
      example = "tskey-client-123456789011-121314151617";
      description = "tailscale auth key - used for easier provisioning";
    };
  };

  config = mkMerge [
    (mkIf (cfg.tailscale.enable == true) {
      #
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"] ''mkdir -v -p /etc/oci.cont/${toString cfg.contName} & chown 1000:1000 /etc/oci.cont/${toString cfg.contName}'';

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "tailscale/tailscale:latest";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${toString cfg.contName}:/var/lib/tailscale"
          "/dev/net/tun:/dev/net/tun"
        ];

        cmd = [];

        environment = {
          TZ = "Australia/Melbourne";
          TS_HOSTNAME = "${cfg.contName}";
          TS_AUTHKEY = "${cfg.authKey}";
          PUID = "1000";
          PGID = "1000";
          TS_EXTRA_ARGS = "--advertise-tags=tag:container --advertise-routes=${cfg.subnet}/24";
          TS_STATE_DIR = "/var/lib/tailscale";
        };

        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.ipAddr}"
          "--privileged"
        ];
      };
    })
  ];
}
