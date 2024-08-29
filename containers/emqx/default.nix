{
  spaghetti,
  secrets,
  lib,
  ...
}: let
  contName = "emqx";
  dir1 = "/home/${spaghetti.user}/.containers/${contName}/data";
  dir2 = "/home/${spaghetti.user}/.containers/${contName}/log";
  # dir3 = "/home/${spaghetti.user}/.containers/${contName}/etc";
in {
  system.activationScripts.makeEMQXDir = lib.stringAfter ["var"] ''mkdir -v -m 777 -p ${toString dir1} ${toString dir2}''; # shitty perms, "temp" workaround

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";

    autoStart = true;

    image = "emqx/emqx:latest";

    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/opt/emqx/data"
      "${toString dir2}:/opt/emqx/log"
      #"${toString dir3}:/opt/emqx/etc"
    ];

    environment = {
      EMQX_HOST = "127.0.0.1";
      EMQX_NAME = "${contName}";
    };

    extraOptions = [
      #"--pull=always"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.emqx}"
    ];
  };
}
