{
  lib,
  secrets,
  ...
}: let
  contName = "zitadel";
  dir1 = "/etc/oci.cont/${contName}/";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1}
  '';

  virtualisation.oci-containers.containers = {
    "${contName}" = {
      hostname = "${contName}";
      autoStart = true;
      image = "ghcr.io/zitadel/zitadel:latest";

      volumes = ["/etc/localtime:/etc/localtime:ro"];

      # using temp masterkey ;)
      cmd = [
        "start-from-init"
        "--masterkey \"CZOjWCFaxeLUdwb1TjvmMFyS8j9ICQNY\""
      ]; #   --tlsMode disabled

      environment = {
        TZ = "Australia/Melbourne";
      };

      extraOptions = [
        "--network=macvlan_lan"
        "--ip=${secrets.ip.zitadel}"
      ];
    };
  };
}
