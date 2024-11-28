{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.haos;
in {
  options.cont.haos = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable home-assistant container";
    };
    autoStart = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "toggle automatic starting of container";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container internal vlan ip address";
    };
    contName = mkOption {
      type = types.str;
      default = "home-assistant-${config.networking.hostName}";
      example = "haos-myhouse";
      description = "container name and mount point name under /etc/oci.cont/";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    image = mkOption {
      type = types.str;
      default = "ghcr.io/home-assistant/home-assistant:latest";
      example = "ghcr.io/home-assistant/home-assistant:beta";
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
          "/etc/oci.cont/${cfg.contName}:/config"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
        };

        extraOptions = [
          "--network=podman-backend:ip=${cfg.vlanIp}"
          # "--network=macvlan_lan:ip=${secrets.ip.haos}"
        ];
      };
    })
  ];
}
