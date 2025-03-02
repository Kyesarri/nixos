{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.dms;
in {
  # https://github.com/docker-mailserver/docker-mailserver/blob/master/compose.yaml
  options.cont.dms = {
    #
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
    fqdn = mkOption {
      type = types.str;
      default = "mail.example.com";
      example = "mymail.coolhost.com";
      description = "your fqdn mailserver";
    };
    vlanIp = mkOption {
      type = types.str;
      default = "12.12.12.1";
      example = "12.12.12.1";
      description = "backend network ip address";
    };
    contName = mkOption {
      type = types.str;
      default = "dms-${config.networking.hostName}";
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
      default = "ghcr.io/docker-mailserver/docker-mailserver:latest";
      example = "ghcr.io/docker-mailserver/docker-mailserver:edge";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      # make dirs via activation script
      system.activationScripts."makeDMSDir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/mail /etc/oci.cont/${cfg.contName}/state /etc/oci.cont/${cfg.contName}/logs /etc/oci.cont/${cfg.contName}/config & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-dms = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.fqdn}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

          "/etc/oci.cont/${cfg.contName}/mail:/var/mail/"
          "/etc/oci.cont/${cfg.contName}/state:/var/mail-state/"
          "/etc/oci.cont/${cfg.contName}/logs:/var/log/mail/"
          "/etc/oci.cont/${cfg.contName}/config:/tmp/docker-mailserver/"
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
