{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.tvheadend;
in {
  options.cont.tvheadend = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
    autoStart = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "toggle automatic starting of container";
    };
    macvlanIp = mkOption {
      type = types.str;
      default = "192.69.4.20";
      example = "192.168.0.100";
      description = "container internal lan ip address";
    };
    /*
    vlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container internal vlan ip address";
    };
    */
    contName = mkOption {
      type = types.str;
      default = "tvheadend-${config.networking.hostName}";
      example = "tvheadend-container-name";
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
      default = "lscr.io/linuxserver/tvheadend:latest";
      example = "lscr.io/linuxserver/tvheadend:latest";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/recordings && chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-tvheadend = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers."${cfg.contName}" = {
        hostname = "${cfg.contName}";

        autoStart = cfg.autoStart;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}:/var/lib/tvheadend:rw"
          "/etc/oci.cont/${cfg.contName}/recordings:/var/lib/tvheadend/recordings:rw"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          GUID = "1000";
        };

        extraOptions = [
          # "--network=podman-backend:ip=${cfg.vlanIp}"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
        ];
      };
    })
  ];
}
