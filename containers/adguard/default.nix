{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.adguard;
in {
  options.cont.adguard = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable adguard container";
    };
    ipAddr = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container macvlan ip address";
    };
    contName = mkOption {
      type = types.str;
      default = "adguard-${config.networking.hostName}";
      example = "adguard-cool-hostname";
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
      default = "adguard/adguardhome:latest";
      example = "adguard/adguardhome:edge";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName} /etc/oci.cont/${cfg.contName}/work /etc/oci.cont/${cfg.contName}/conf & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}/work:/opt/adguardhome/work"
          "/etc/oci.cont/${cfg.contName}/conf:/opt/adguardhome/conf"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
        };

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.ipAddr}"
          "--network=podman-backend"
        ];
      };
    })
  ];
}
