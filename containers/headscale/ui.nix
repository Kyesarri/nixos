{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.headscale.ui;
in {
  options.cont.headscale.ui = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable headscale ui container";
    };
    macvlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container macvlan ip address";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container vlan ip address";
    };
    autoStart = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "autostart container";
    };
    contName = mkOption {
      type = types.str;
      default = "headscale-ui-${config.networking.hostName}";
      example = "apply-directly-to-headscale-ui";
      description = "container name";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    image = mkOption {
      type = types.str;
      default = "ghcr.io/gurucomputing/headscale-ui:latest";
      example = "ghcr.io/gurucomputing/headscale-ui:latest";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = cfg.autoStart;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
        };

        cmd = ["serve"];

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          # "--network=podman-backend:ip=${cfg.vlanIp}" # leaving out currently - less things moving to get started with container
        ];
      };
    })
  ];
}
