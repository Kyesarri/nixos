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
    mqtt = {
      serial = mkOption {
        type = types.str;
        default = "";
        example = "tcp://192.1.2.3:6638";
        description = "";
      };
      server = mkOption {
        type = types.str;
        default = "";
        example = "mqtt://192.1.2.3:1883";
        description = "";
      };
      user = mkOption {
        type = types.str;
        default = "zigbee2mqtt";
        example = "zigbee2mqtt";
      };
      password = mkOption {
        type = types.str;
        default = "123passwordxyz";
        example = "password123";
      };
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"] ''
          mkdir -v -p /etc/oci.cont/${cfg.contName} & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment = {
        shellAliases = {
          cont-zigbee2mqtt = "sudo podman pull ${cfg.image}";
        };

        etc."oci.cont/${cfg.contName}/configuration.yaml" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''
            homeassistant: true

            frontend: true

            force_disable_retain: false

            availability:
              active:
                timeout: 10
              passive:
                timeout: 1500

            mqtt:
              server: ${cfg.mqtt.server}
              user: ${cfg.mqtt.user}
              password: ${cfg.mqtt.password}
              client_id: ${cfg.mqtt.user}
              reject_unauthorized: false
              include_device_information: true
              keepalive: 60
              version: 4

            serial:
              port: ${cfg.mqtt.serial}
              adapter: auto

            advanced:
              transmit_power: 20

            devices:
              '0x8c65a3fffe6ee490':
                friendly_name: Unused Motion Sensor
              '0x001788010cd6eff8':
                friendly_name: Hallway Motion Sensor
              '0xd44867fffe48afd8':
                friendly_name: Toilet Motion Sensor
              '0x048727fffe7a0408':
                friendly_name: Entry Door Sensor
              '0x048727fffea31907':
                friendly_name: Back Door Sensor
              '0x30fb10fffee3f490':
                friendly_name: Bedroom Lamp
                color_sync: true
                state_action: true
                transition: 5
              '0x001788010237c13c':
                friendly_name: Toilet Light
                color_sync: true
                state_action: true
                transition: 5
              '0x001788010237c61c':
                friendly_name: Bathroom Light
                color_sync: true
                state_action: true
                transition: 5
              '0x0017880102e0674c':
                friendly_name: Hallway Light
                color_sync: true
                state_action: true
                transition: 5
          '';
        };
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
