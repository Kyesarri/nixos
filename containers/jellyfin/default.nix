/*
Jellyfin is a Free Software Media System that puts you in control of managing and streaming your media.
*/
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.jellyfin;
in {
  options.cont.jellyfin = {
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
      default = "jellyfin-${config.networking.hostName}";
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
      default = "linuxserver/jellyfin:latest";
      example = "jellyfin/jellyfin:latest";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/config mkdir -v -p /etc/oci.cont/${cfg.contName}/data & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-jellyfin = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

          "/dev/dri:/dev/dri" # hardware accel;

          "/etc/oci.cont/${cfg.contName}/config:/config"
          "/etc/oci.cont/${cfg.contName}/data:/core/data"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
        };

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
