{
  lib,
  pkgs,
  secrets,
  ...
}: let
  contName = "zitadel";
  dir1 = "/etc/oci.cont/${contName}";
in {
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"]
    ''mkdir -v -p ${toString dir1} & ${toString dir1}-db'';

  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    ExecStop = "${pkgs.podman}/bin/podman network rm -f zitadel-net";
  };
  script = ''
    podman network exists zitadel-net || podman network create zitadel-net
  '';

  virtualisation.oci-containers.containers = {
    # zitadel
    "${contName}" = {
      hostname = "${contName}";
      autoStart = true;
      image = "ghcr.io/zitadel/zitadel:latest";
      volumes = ["/etc/localtime:/etc/localtime:ro"];
      cmd = ["start-from-init" "--masterkeyFromEnv"];
      environment = {
        ZITADEL_MASTERKEY = "${toString secrets.keys.zitadel}";
        TZ = "Australia/Melbourne";
        # ZITADEL_DATABASE_COCKROACH_HOST = "";
        # ZITADEL_DATABASE_COCKROACH_PORT = "26257";
      };
      extraOptions = [
        "--network=zitadel"
        "--network=macvlan_lan"
        "--ip=${secrets.ip.zitadel}"
      ];
    };

    # zitadel-db
    "${contName}-db" = {
      hostname = "${contName}-db";
      autoStart = true;
      image = "cockroachdb/cockroach:latest";
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${toString dir1}:/cockroach/cockroach-data"
      ];
      cmd = ["start-single-node"];
      environment = {
        COCKROACH_DATABASE = "${toString secrets.zitadel.dbname}";
        COCKROACH_USER = "${toString secrets.zitadel.dbuser}";
        COCKROACH_PASSWORD = "${toString secrets.zitadel.dbpass}";
        PUID = "1000";
        PGID = "1000";
        TZ = "Australia/Melbourne";
      };
      extraOptions = [
        "--network=zitadel"
      ];
    };
  };
}
