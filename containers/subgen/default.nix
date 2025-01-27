/*
subgen
Autogenerate subtitles using OpenAI Whisper Model via Jellyfin, Plex, Emby, Tautulli, or Bazarr
*/
{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.cont.subgen;
in {
  options.cont.subgen = {
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
      default = "subgen-${config.networking.hostName}";
      example = "container-cool-hostname";
      description = "container name, is also used for container volume dir name";
    };
    timeZone = mkOption {
      type = types.str;
      default = "Australia/Melbourne";
      example = "Australia/Broken_Hill";
      description = "database timezone";
    };
    plexServer = mkOption {
      type = types.str;
      default = "null";
      example = "10.0.1.2:32400";
      description = "internal ip of your plex server";
    };
    plexToken = mkOption {
      type = types.str;
      default = "gudtokenhere";
      example = "bettertokenhere";
      description = "see https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/";
    };
    image = mkOption {
      type = types.str;
      default = "mccloud/subgen:latest";
      example = "mccloud/subgen:cpu";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      ##

      system.activationScripts."makeSubGenDir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/models & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.etc = {};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

          /*
          "/hdda/movies:/movies/hdda"
          "/hddb/movies:/movies/hddb"
          "/hddc/movies:/movies/hddc"
          "/hddd/movies:/movies/hddd"
          "/hdde/movies:/movies/hdde"
          "/hddf/movies:/movies/hddf"
          "/hddg/movies:/movies/hddg"
          "/hddh/movies:/movies/hddh"
          "/hddi/movies:/movies/hddi"

          "/hdda/tv_shows:/tv/hdda"
          "/hddb/tv_shows:/tv/hddb"
          "/hddc/tv_shows:/tv/hddc"
          "/hddd/tv_shows:/tv/hddd"
          "/hdde/tv_shows:/tv/hdde"
          "/hddf/tv_shows:/tv/hddf"
          "/hddg/tv_shows:/tv/hddg"
          "/hddh/tv_shows:/tv/hddh"
          "/hddi/tv_shows:/tv/hddi"
          */

          # testing same paths as plex sees
          "/hdda/movies:/movies/hdda"
          "/hddb/movies:/movies/hddb"
          "/hddc/movies:/movies/hddc"
          "/hddd/movies:/movies/hddd"
          "/hdde/movies:/movies/hdde"
          "/hddf/movies:/movies/hddf"
          "/hddg/movies:/movies/hddg"
          "/hddh/movies:/movies/hddh"
          "/hddi/movies:/movies/hddi"

          "/hdda/tv_shows:/tv_shows/hdda"
          "/hddb/tv_shows:/tv_shows/hddb"
          "/hddc/tv_shows:/tv_shows/hddc"
          "/hddd/tv_shows:/tv_shows/hddd"
          "/hdde/tv_shows:/tv_shows/hdde"
          "/hddf/tv_shows:/tv_shows/hddf"
          "/hddg/tv_shows:/tv_shows/hddg"
          "/hddh/tv_shows:/tv_shows/hddh"
          "/hddi/tv_shows:/tv_shows/hddi"

          "/etc/oci.cont/${cfg.contName}/models:/subgen/models"
        ];

        environment = {
          TZ = "${cfg.timeZone}";
          PUID = "1000";
          PGID = "1000";
          #TODO
          WHISPER_MODEL = "medium";
          WHISPER_THREADS = "4";
          PROCADDEDMEDIA = "true";
          PROCMEDIAONPLAY = "false";
          NAMESUBLANG = "aa";
          SKIPIFINTERNALSUBLANG = "eng";
          PLEXTOKEN = "${cfg.plexToken}"; #ADDME
          # PLEXSERVER = "${cfg.plexServer};"; #ADDME
          # JELLYFINTOKEN = "${cfg.jellyToken}"; #ADDME
          # JELLYFINSERVER = "${cfg.jellyServer}"; #ADDME
          WEBHOOKPORT = "9000";
          CONCURRENT_TRANSCRIPTIONS = "2";
          WORD_LEVEL_HIGHLIGHT = "False";
          DEBUG = "true";
          USE_PATH_MAPPING = "false";
          PATH_MAPPING_FROM = "/tv";
          PATH_MAPPING_TO = "/Volumes/TV";
          TRANSCRIBE_DEVICE = "cpu";
          CLEAR_VRAM_ON_COMPLETE = "true";
          MODEL_PATH = "./models";
          UPDATE = "false";
          APPEND = "false";
          USE_MODEL_PROMPT = "false";
          CUSTOM_MODEL_PROMPT = "";
          LRC_FOR_AUDIO_FILES = "true";
          CUSTOM_REGROUP = "cm_sl=84_sl=42++++++1";
          #TODO
        };

        extraOptions = [
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
