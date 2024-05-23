{
  secrets,
  lib,
  ...
}: let
  contName = "cpai";
  dir1 = "/etc/oci.cont/${contName}/etc/codeproject/ai";
  dir2 = "/etc/oci.cont/${contName}/app/modules";
in {
  system.activationScripts.makeCodeProjectDir = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} ${toString dir2} & chown 1000:1000 ${toString dir1} & chown 1000:1000 ${toString dir2}
  '';

  networking.firewall.allowedTCPPorts = [32168];
  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "codeproject/ai-server:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/etc/codeproject/ai"
      "${toString dir2}:/app/modules"
    ];

    environment = {
      PUID = "1000";
      PGID = "1000";
    };

    extraOptions = [
      "--network=macvlan_lan"
      "--ip=${secrets.ip.cpai}"
      # "--device=/dev/apex_0:/dev/apex_0"
    ];
  };
}
