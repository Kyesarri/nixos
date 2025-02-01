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
      default = null;
      example = "10.10.10.1";
      description = "container macvlan ip address";
    };
    #
    vlanIp = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "12.12.12.1";
      description = "backend network ip address";
    };
    #
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
    #
    plexServer = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "10.0.1.2:32400";
      description = "internal ip of your plex server";
    };
    #
    plexToken = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = "your plex token ere'";
      description = "see https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/";
    };
    #
    image = mkOption {
      type = types.str;
      default = "mccloud/subgen:latest";
      example = "mccloud/subgen:cpu";
      description = "container image";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make${cfg.contName}dir" =
        lib.stringAfter ["var"]
        ''mkdir -v -p /etc/oci.cont/${cfg.contName}/models & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.etc = {};

      virtualisation.oci-containers.containers.${cfg.contName} = {
        hostname = "${cfg.contName}";

        autoStart = true;

        image = "${cfg.image}";

        volumes = [
          "/etc/localtime:/etc/localtime:ro"

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

          WHISPER_MODEL = "medium";
          WHISPER_THREADS = "4";
          PROCADDEDMEDIA = "true"; # will gen subtitles for all media added regardless of existing external/embedded subtitles (based off of SKIPIFINTERNALSUBLANG)
          PROCMEDIAONPLAY = "false"; # will gen subtitles for all played media regardless of existing external/embedded subtitles (based off of SKIPIFINTERNALSUBLANG)
          NAMESUBLANG = "aa"; # allows you to pick what it will name the subtitle. Instead of using EN, I'm using AA, so it doesn't mix with exiting external EN subs, and AA will populate higher on the list in Plex.
          SKIPIFINTERNALSUBLANG = "eng";
          PLEXTOKEN = "${cfg.plexToken}"; # probs will disable and leave bazarr handle all
          PLEXSERVER = "${cfg.plexServer};"; # see above
          TRANSCRIBE_FOLDERS = "/tv_shows|/movies";
          MONITOR = "false"; # Will monitor TRANSCRIBE_FOLDERS for real-time changes to see if we need to generate subtitles
          TRANSCRIBE_OR_TRANSLATE = "translate";
          # JELLYFINTOKEN = "${cfg.jellyToken}"; #ADDME
          # JELLYFINSERVER = "${cfg.jellyServer}"; #ADDME
          PLEX_QUEUE_SERIES = "false"; # Will queue the whole Plex series for subtitle generation if subgen is triggered
          WEBHOOKPORT = "9000";
          CONCURRENT_TRANSCRIPTIONS = "4"; # Number of files it will transcribe in parallel
          WORD_LEVEL_HIGHLIGHT = "true"; # Highlights each words as it's spoken in the subtitle
          DEBUG = "true";
          USE_PATH_MAPPING = "false"; # Similar to sonarr and radarr path mapping, this will attempt to replace paths on file systems that don't have identical paths. Currently only support for one path replacement
          PATH_MAPPING_FROM = "/tv"; # not used atm, above toggled
          PATH_MAPPING_TO = "/Volumes/TV"; # same as above
          TRANSCRIBE_DEVICE = "cpu"; # Can transcribe via gpu (Cuda only) or cpu. Takes option of "cpu", "gpu", "cuda".
          CLEAR_VRAM_ON_COMPLETE = "true"; # This will delete the model and do garbage collection when queue is empty. Good if you need to use the VRAM for something else.
          MODEL_PATH = "/subgen/models"; # container is odd, this "works" then throws errors - idk man
          UPDATE = "false";
          APPEND = "false";
          USE_MODEL_PROMPT = "false";
          CUSTOM_MODEL_PROMPT = "";
          LRC_FOR_AUDIO_FILES = "true";
          CUSTOM_REGROUP = "cm_sl=84_sl=42++++++1";
        };

        extraOptions = [
          "--privileged"
          "--network=macvlan_lan:ip=${cfg.macvlanIp}"
          # "--network=podman-backend:ip=${cfg.vlanIp}"
        ];
      };
    })
  ];
}
