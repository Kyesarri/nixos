{
  lib,
  pkgs,
  secrets,
  ...
}: let
  contName = "zitadel";
  dir1 = "/etc/oci.cont/${contName}";
in {
  # create directories for containeers
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"]
    ''mkdir -v -p ${toString dir1} ${toString dir1}-db'';

  # check if podman network exists, if it doesn't create it
  /*
  systemd.services."podman-network-zitadel-net" = {
    path = [pkgs.podman];
    script = ''podman network exists zitadel-net || podman network create --subnet 10.0.0.0/16 --ip-range 10.0.0.200/16 --gateway ${toString secrets.ip.erying} zitadel-net'';
    # wantedBy = ["podman-zitadel-db.service" "podman-zitadel.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "${pkgs.podman}/bin/podman network rm -f zitadel-net";
    };
  };
  */

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
        ZITADEL_DATABASE_COCKROACH_HOST = "${contName}-db";
        ZITADEL_DATABASE_COCKROACH_PORT = "26257";
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
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "${toString dir1}-db:/cockroach/cockroach-data"
      ];
      cmd = ["start-single-node" "--insecure"];
      environment = {
        COCKROACH_DATABASE = "${toString secrets.zitadel.dbname}";
        COCKROACH_USER = "${toString secrets.zitadel.dbuser}";
        COCKROACH_PASSWORD = "${toString secrets.zitadel.dbpass}";
        TZ = "Australia/Melbourne";
      };
      extraOptions = [
        "--network=podman"
      ];
    };
  };
}
