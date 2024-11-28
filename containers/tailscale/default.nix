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
    macvlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container ip address";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container ip address";
    };
    vlanSubnet = mkOption {
      type = types.str;
      default = "10.10.0.0";
      example = "10.10.10.0";
      description = "container ip address";
    };
    subnet = mkOption {
      type = types.str;
      default = "10.10.0.0";
      example = "10.10.10.0";
      description = "container subnet";
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
    /*
    authKey = mkOption {
      type = types.str;
      default = "";
      example = "tskey-client-123-xyz";
      description = "tailscale auth key - used for easier provisioning - not sure if is broken or just my systems playing funny-buggers";
    };
    */
    image = mkOption {
      type = types.str;
      default = "tailscale/tailscale:latest";
      example = "tailscale/tailscale:latest";
      description = "container image";
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
          TS_EXTRA_ARGS = "--advertise-tags=tag:container --advertise-routes=${cfg.subnet}/24,${cfg.vlanSubnet}/24";
          TS_STATE_DIR = "/var/lib/tailscale";
        };

        # needed to add interface names to each interface, tailscale was trying to reach the wwws
        # via the podman-backend network - which is currently isolated -- nope i was mistaken, wasn't isolated --
        # podman-backend was receiving eth0 by default
        #
        # is not actually the issue I believe, bringing that network down now :(
        #
        # issue being the internal podman-backend network had a gateway - tailscale does not like
        # networks with a gateway but no connectivity, fixed by running --internal on the
        # systemd service bringing up the internal network
        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.macvlanIp},interface_name=eth0"
          "--network=podman-backend:ip=${cfg.vlanIp}interface_name=eth1"
          "--privileged"
        ];
      };
    })
  ];
}
