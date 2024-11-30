{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.headscale;
in {
  options.cont.headscale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable headscale container - an opensource self-hosted tailscale control server";
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
      description = "container macvlan ip address";
    };
    autoStart = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "autostart container";
    };
    contName = mkOption {
      type = types.str;
      default = "headscale-${config.networking.hostName}";
      example = "apply-directly-to-headscale";
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
      default = "headscale/headscale:latest";
      example = "headscale/headscale:latest-debug";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName} && chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = cfg.autoStart;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}:/etc/headscale"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          # PUID = "1000";
          # PGID = "1000";
        };

        cmd = ["serve"];

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          # "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
