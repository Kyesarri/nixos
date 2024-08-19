{
  lib,
  secrets,
  ...
}: let
  contName = "zitadel";
  dir1 = "/etc/oci.cont/${contName}";
in {
  # containers are both running insecure without https
  # please don't deploy outside of internal networks, or just dont deploy anywhere :D
  #
  # running on host - need to forward port 8080

  # create directories for containeers
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"]
    ''mkdir -v -p ${toString dir1} ${toString dir1}-db'';

  virtualisation.oci-containers.containers = {
    # could add nginx here, to rest in-front of the other two containers
    # https://zitadel.com/docs/self-hosting/manage/reverseproxy/nginx

    # zitadel
    "${contName}" = {
      hostname = "${contName}";
      autoStart = true;
      image = "ghcr.io/zitadel/zitadel:latest";
      volumes = ["/etc/localtime:/etc/localtime:ro"];
      cmd = ["start-from-init" "--masterkeyFromEnv"];

      # "hostport:containerport"
      ports = ["8080:8080"];
      environment = {
        ZITADEL_MASTERKEY = "${toString secrets.keys.zitadel}";
        TZ = "Australia/Melbourne";
        ZITADEL_DATABASE_COCKROACH_HOST = "${contName}-db";
        ZITADEL_DATABASE_COCKROACH_PORT = "26257";
        ZITADEL_EXTERNALSECURE = "false"; # FIXME
        ZITADEL_TLS_ENABLED = "false"; # FIXME
        ZITADEL_EXTERNALDOMAIN = "https://zitadel.home";
        ZITADEL_TELEMETRY_ENABLED = "false";
        ZITADEL_DATABASE_COCKROACH_DATABASE = "${toString secrets.zitadel.dbname}";
        ZITADEL_DATABASE_COCKROACH_USER_USERNAME = "${toString secrets.zitadel.dbuser}";
        ZITADEL_DATABASE_COCKROACH_USER_PASSWORD = ""; # passwords cannot be set when using insecure mode
        ZITADEL_DATABASE_COCKROACH_USER_SSL_MODE = "disable";
      };
      extraOptions = [
        "--network=podman"
      ];
    };

    # zitadel-db
    "${contName}-db" = {
      hostname = "${contName}-db";
      autoStart = true;
      image = "cockroachdb/cockroach:latest";
      volumes = ["/etc/localtime:/etc/localtime:ro" "${toString dir1}-db:/cockroach/cockroach-data"];
      cmd = ["start-single-node" "--insecure"];

      # don't feel the need to have the db webui exposed
      # "hostport:containerport"
      # ports = ["80:8080"];
      environment = {
        COCKROACH_DATABASE = "${toString secrets.zitadel.dbname}";
        COCKROACH_USER = "${toString secrets.zitadel.dbuser}";
        COCKROACH_PASSWORD = ""; # passwords cannot be set when using insecure mode
        TZ = "Australia/Melbourne";
      };
      extraOptions = [
        "--network=podman"
      ];
    };
  };
}
