/*
subs ai
Subtitles generation tool (Web-UI + CLI + Python package) powered by OpenAI's Whisper and its variants
*/
{
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
      /*
      system.activationScripts."make${cfg.contName}Dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName} & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';
      */
      environment.etc = {};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

          # "/etc/oci.cont/${cfg.contName}:/subsai" nup

          "/hdda/movies:/media_files/movies/hdda"
          "/hddb/movies:/media_files/movies/hddb"
          "/hddc/movies:/media_files/movies/hddc"
          "/hddd/movies:/media_files/movies/hddd"
          "/hdde/movies:/media_files/movies/hdde"
          "/hddf/movies:/media_files/movies/hddf"
          "/hddg/movies:/media_files/movies/hddg"
          "/hddh/movies:/media_files/movies/hddh"
          "/hddi/movies:/media_files/movies/hddi"

          "/hdda/tv_shows:/media_files/tv_shows/hdda"
          "/hddb/tv_shows:/media_files/tv_shows/hddb"
          "/hddc/tv_shows:/media_files/tv_shows/hddc"
          "/hddd/tv_shows:/media_files/tv_shows/hddd"
          "/hdde/tv_shows:/media_files/tv_shows/hdde"
          "/hddf/tv_shows:/media_files/tv_shows/hddf"
          "/hddg/tv_shows:/media_files/tv_shows/hddg"
          "/hddh/tv_shows:/media_files/tv_shows/hddh"
          "/hddi/tv_shows:/media_files/tv_shows/hddi"
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
