{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.radicale;
in {
  options.cont.radicale = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
    macvlanIp = mkOption {
      type = types.str;
      default = "10.10.0.200";
      example = "10.10.10.1";
      description = "container macvlan ip address";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "12.12.12.1";
      example = "12.12.12.1";
      description = "backend network ip address";
    };
    contName = mkOption {
      type = types.str;
      default = "radicale-${config.networking.hostName}";
      example = "container-cool-hostname";
      description = "container name, is also used for container volume dir name";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    image = mkOption {
      type = types.str;
      default = "tomsquest/docker-radicale:latest";
      example = "tomsquest/docker-radicale:next";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      system.activationScripts."makeRadicaleDir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/data /etc/oci.cont/${cfg.contName}/config & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';
      environment.etc = {
        #
        "oci.cont/${cfg.contName}/config/config" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''
            [server]
            hosts = 0.0.0.0:5232

            [auth]
            type = htpasswd
            htpasswd_filename = /config/users
            htpasswd_encryption = bcrypt

            [storage]
            filesystem_folder = /data/collections
          '';
        };
        #
        "oci.cont/${cfg.contName}/config/users" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''
            kel:${secrets.password.radicale}
          '';
        };
      };
      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}/data:/data"
          "/etc/oci.cont/${cfg.contName}/config:/config:ro"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
        };

        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          "--network=podman-backend:ip=${cfg.vlanIp}"
          "--privileged"
        ];
      };
    })
  ];
}
