{lib, ...}: let
  contName = "proxarr";
  dir1 = "/etc/oci.cont/arr/${contName}/data";
  dir2 = "/etc/oci.cont/arr/${contName}/letsencrypt";
in {
  system.activationScripts."make${contName}Dir" = lib.stringAfter ["var"] ''
    mkdir -v -p ${toString dir1} ${toString dir2} & chown 1000:1000 ${toString dir1} & chown 1000:1000 ${toString dir2}
  '';

  virtualisation.oci-containers.containers."${contName}" = {
    hostname = "${contName}";
    autoStart = true;
    image = "docker.io/jc21/nginx-proxy-manager:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/data"
      "${toString dir2}:/etc/letsencrypt"
    ];

    environment = {};

    extraOptions = [];
  };
}
