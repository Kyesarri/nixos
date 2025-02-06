/*
Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
*/
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.nzbget;
in {
  options.cont.nzbget = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
    #
    macvlanIp = mkOption {
      type = types.nullOr types.str;
      default = "";
      example = "10.10.10.1";
      description = "container macvlan ip address";
    };
    #
    vlanIp = mkOption {
      type = types.nullOr types.str;
      default = "";
      example = "12.12.12.1";
      description = "backend network ip address";
    };
    #
    contName = mkOption {
      type = types.str;
      default = "nzbget-${config.networking.hostName}";
      example = "container-cool-hostname";
      description = "container name, is also used for container volume dir name and activation script";
    };

    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    #
    image = mkOption {
      type = types.str;
      default = "linuxserver/nzbget:latest";
      example = "linuxserver/nzbget:testing";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/config & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-nzbget = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

          "/etc/oci.cont/${cfg.contName}/config:/config"

          "/hddf/nzb:/downloads"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000"; # may need to chage this? lets test without first
        };

        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
