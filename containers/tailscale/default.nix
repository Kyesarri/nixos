{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.tailscale;
in {
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
    contName = mkOption {
      type = types.str;
      default = "tailscale-${config.networking.hostName}-subnet";
      example = "my-fabulous-subnet-router";
      description = "container name";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "set database timezone";
    };
    authKey = mkOption {
      type = types.str;
      default = "change-me";
      example = "tskey-client-123456789011-121314151617";
      description = "tailscale auth key - used for easier provisioning - not sure if is broken or just my systems playing funny-buggers";
    };
    image = mkOption {
      type = types.str;
      default = "tailscale/tailscale:latest";
      example = "adguard/adguardhome";
      description = "image for container";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"] ''mkdir -v -p /etc/oci.cont/${toString cfg.contName} & chown 1000:1000 /etc/oci.cont/${toString cfg.contName}'';

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${toString cfg.contName}:/var/lib/tailscale"
          "/dev/net/tun:/dev/net/tun"
        ];

        cmd = [];

        environment = {
          TZ = "${cfg.timeZone}";
          TS_HOSTNAME = "${cfg.contName}";
          # neither were working all of a sudden, smh
          # TS_AUTHKEY = "${secrets.password.tailscale}";
          # TS_AUTHKEY = "${cfg.authKey}";
          PUID = "1000";
          PGID = "1000";
          TS_EXTRA_ARGS = "--advertise-tags=tag:container --advertise-routes=${cfg.subnet}/24";
          TS_STATE_DIR = "/var/lib/tailscale";
        };

        # needed to add interface names to each interface, tailscale was trying to reach the wwws
        # via the podman-backend network - which is currently isolated
        # podman-backend was receiving eth0 by default
        #
        # is not actually the issue I believe testing bringing that network down now :(
        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.ipAddr},interface_name=eth0"
          # "--network=podman-backend:interface_name=eth1"
          "--privileged"
        ];
      };
    })
  ];
}
