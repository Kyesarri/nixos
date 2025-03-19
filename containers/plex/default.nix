{
  config,
  lib,
  ...
}:
with lib; let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfg = config.cont.plex;
in {
  options.cont.plex = {
    #
    enable = mkEnableOption "plex";

    autoStart = mkOption {
      type = types.bool;
      default = true;
      example = false;
      description = "autostart container";
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
      default = "plex-${config.networking.hostName}";
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
      default = "lscr.io/linuxserver/plex:latest";
      example = "lscr.io/linuxserver/plex:latest";
      description = "container image";
    };
  };
  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      system.activationScripts."make-${cfg.contName}-dir" =
        lib.stringAfter ["var"] ''mkdir -v -p /etc/oci.cont/${cfg.contName} & chown -R 1000:1000 /etc/oci.cont/${cfg.contName}'';

      environment.shellAliases = {cont-plex = "sudo podman pull ${cfg.image}";};

      virtualisation.oci-containers.containers.${contName} = {
        hostname = "${cfg.contName}";

        autoStart = "${cfg.autoStart}";

        image = "${cfg.image}";

        ports = [];

        volumes = [
          "/etc/localtime:/etc/localtime:ro"
          "/dev/dri:/dev/dri"

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

          "/etc/oci.cont/${cfg.contName}:/config"
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
