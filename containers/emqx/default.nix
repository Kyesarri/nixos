{
  spaghetti,
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  contName = "emqx";
  dir1 = "/home/${spaghetti.user}/.containers/${contName}/data";
  dir2 = "/home/${spaghetti.user}/.containers/${contName}/etc";
  dir3 = "/home/${spaghetti.user}/.containers/${contName}/log";
in {
  system.activationScripts.makeEMQXDir = lib.stringAfter ["var"] ''
    mkdir -v -m 777 -p ${toString dir1} ${toString dir2} ${toString dir3}
  ''; # shitty perms, "temp" workaround

  virtualisation.oci-containers.containers.${contName} = {
    hostname = "${contName}";
    autoStart = true;
    image = "ghcr.io/emqx/emqx:latest";
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "${toString dir1}:/opt/emqx/data"
      "${toString dir2}:/opt/emqx/etc"
      "${toString dir3}:/opt/emqx/log"
    ];
    environment = {
      EMQX_NODE_NAME = "${contName}";
    };
    extraOptions = [
      "--pull=always"
      "--network=macvlan_lan"
      "--ip=${secrets.ip.emqx}"
    ];
  };
}
