/*
subs ai
Subtitles generation tool (Web-UI + CLI + Python package) powered by OpenAI's Whisper and its variants
*/
{
  secrets,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.subsai;
in {
  options.cont.subsai = {
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
      default = "subsai-${config.networking.hostName}";
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
      default = "absadiki/subsai:latest";
      example = "absadiki/subsai:main";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##
      system.activationScripts."makeSubsAIDir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/data /etc/oci.cont/${cfg.contName}/config & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';
      environment.etc = {
        /*
        "oci.cont/${cfg.contName}/config/config" = {
          mode = "644";
          uid = 1000;
          gid = 1000;
          text = ''
            #TODO
          '';
        };
        */
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
        ];
      };
    })
  ];
}
