{
  lib,
  secrets,
  ...
}: let
  contName = "zitadel";
  dir1 = "/etc/oci.cont/${contName}/.data";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} & chown 1000:1000 ${toString dir1}
  '';

  virtualisation.oci-containers.containers = {
    "${contName}" = {
      hostname = "${contName}";
      autoStart = true;
      image = "ghcr.io/zitadel/zitadel:latest";

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
      ];

      cmd = [
        "start-from-init"
        "--masterkey /"
        "MasterkeyNeedsToHave32Characters/"
        "--tlsMode disabled"
      ];

      environment = {
        PUID = "1000";
        PGID = "1000";
        TZ = "Australia/Melbourne";
      };

      extraOptions = [
        "--network=macvlan_lan"
        "--ip=${secrets.ip.zigbee2mqtt}"
      ];
    };
  };
}
