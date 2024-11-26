{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.nginx-lan;
in {
  options.cont.nginx-lan = {
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
      default = "nginx-lan-${config.networking.hostName}";
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
      default = "docker.io/jc21/nginx-proxy-manager:latest";
      example = "docker.io/jc21/nginx-proxy-manager:latest";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      system.activationScripts."makeNginxLanDir" =
        lib.stringAfter
        ["var"] ''mkdir -v -p /etc/oci.cont/${cfg.contName}/letsencrypt /etc/oci.cont/${cfg.contName}/data & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/etc/oci.cont/${cfg.contName}:/data"
          "/etc/oci.cont/${cfg.contName}:/etc/letsencrypt"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
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
