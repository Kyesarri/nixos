# Incredibly secure, fast and light WebDav Server, built from Nginx official image
# bare minimum with no bells and whistles
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.webdav;
in {
  options.cont.webdav = {
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable container";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "12.12.12.1";
      example = "12.12.12.1";
      description = "backend network ip address";
    };
    userName = mkOption {
      type = types.str;
      default = "webdav";
      example = "webdav";
      description = "username used for webdav";
    };
    password = mkOption {
      type = types.str;
      default = "webdav";
      example = "webdav";
      description = "password, string";
    };
    contName = mkOption {
      type = types.str;
      default = "webdav-${config.networking.hostName}";
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
      default = "maltokyo/docker-nginx-webdav:latest";
      example = "maltokyo/docker-nginx-webdav:latest";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter
        ["var"] ''mkdir -v -p /etc/oci.cont/${cfg.contName} & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-webdav = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}:/media/data"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          USERNAME = "${cfg.userName}";
          PASSWORD = "${cfg.password}";
        };

        extraOptions = [
          "--network=podman-backend:ip=${cfg.vlanIp}"
          "--privileged"
        ];
      };
    })
  ];
}
