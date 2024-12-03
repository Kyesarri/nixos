{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.zigbee2mqtt;
in {
  options.cont.zigbee2mqtt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable zigbee to mqtt container";
    };
    macvlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container macvlan ip";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container vlan ip";
    };
    contName = mkOption {
      type = types.str;
      default = "zigbee2mqtt-${config.networking.hostName}";
      example = "my-broken-z2m-container";
      description = "container name";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "set database timezone";
    };
    image = mkOption {
      type = types.str;
      default = "koenkk/zigbee2mqtt:latest";
      example = "koenkk/zigbee2mqtt:latest-dev";
      description = "container image";
    };
    mqtt-serial = mkOption {
      type = types.str;
      default = "";
      example = "tcp://192.1.2.3:6638";
      description = "";
    };
    mqtt-server = mkOption {
      type = types.str;
      default = "";
      example = "mqtt://192.1.2.3:1883";
      description = "";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"] ''
          mkdir -v -p /etc/oci.cont/${cfg.contName} & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.etc."oci.cont/${cfg.contName}/configuration.yaml" = {
        mode = "644";
        uid = 1000;
        gid = 1000;
        text = ''
          permit_join: true
          mqtt:
            server: ${cfg.mqtt-server}
          serial:
            port: ${cfg.mqtt-serial}
          frontend: true
        '';
      };

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}:/app/data"
        ];

        environment = {
          PUID = "1000";
          PGID = "1000";
          TZ = "${cfg.timeZone}";
        };

        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          # "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
