# cockroachdb - see container zitadel
{
  lib,
  secrets,
  ...
}: let
  contName = "cockroachdb";
  dir1 = "/etc/oci.cont/${contName}/.data";
in {
  system.activationScripts."make${contName}Dir" =
    lib.stringAfter ["var"]
    ''mkdir -v -p ${toString dir1}''; # & chown 1000:1000 ${toString dir1}

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "cockroachdb/cockroach:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/cockroach/cockroach-data"
    ];

    cmd = ["start-single-node"];

    environment = {
      COCKROACH_DATABASE = "";
      COCKROACH_USER = "";
      COCKROACH_PASSWORD = "";
      # PUID = "1000";
      # PGID = "1000";
      TZ = "Australia/Melbourne";
    };

    extraOptions = [
      "--network=podman"
    ];
  };
}
