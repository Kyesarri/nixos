# inspo from https://github.com/mkuf/prind
{
  secrets,
  pkgs,
  lib,
  ...
}: let
  # config happens here, change values as you desire
  dir = "/etc/oci.cont/fweedee"; # set our root directory for containers
  time = "/etc/localtime:/etc/localtime:ro"; # read only our server time to containers
  prefix = "fweedee";

  shared = {
    log = "${dir}/shared/log";
    run = "${dir}/shared/run";
    config = "${dir}/shared/config";
    gcodes = "${dir}/shared/gcodes";
  };

  nginx = {
    ip = "${secrets.ip.fweedee-nginx}"; # only this container requires an ip
    dir = "${dir}/nginx"; # container's root directory, volumes stored here per-container
    name = "${prefix}-nginx"; # container name
    image = "jc21/nginx-proxy-manager:latest"; # container image
    v1 = "${nginx.dir}/letsencrypt"; # volumes
    v2 = "${nginx.dir}/data";
  };

  klipper = {
    dir = "${toString dir}/klipper";
    name = "${prefix}-klipper";
    image = "mkuf/klipper:latest";
  };

  moonraker = {
    dir = "${toString dir}/moonraker";
    name = "${prefix}-moonraker";
    image = "mkuf/moonraker:latest";
  };

  octoprint = {
    dir = "${toString dir}/octoprint";
    name = "${prefix}-octoprint";
    image = "octoprint/octoprint:minimal";
  };

  fluidd = {
    name = "${prefix}-fluidd";
    image = "ghcr.io/fluidd-core/fluidd:latest";
  };
  mainsail = {
    name = "${prefix}-mainsail";
    image = "ghcr.io/mainsail-crew/mainsail:edge";
  };
in {
  # create a systemd service to bring up our pod
  systemd.services."fweedee" = {
    description = "Start podman 'fweedee' pod";

    # don't start without network-online being up
    wants = ["network-online.target"];
    after = ["network-online.target"];

    # our containers require fweedee pod to be up before they start
    requiredBy = [
      "podman-${klipper.name}.service"
      "podman-${nginx.name}.service"
      "podman-${moonraker.name}.service"
      "podman-${octoprint.name}.service"
    ];

    # unsure, might not be required?
    unitConfig.RequiresMountsFor = "/run/containers";

    # script to run (create the pod)
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "-${pkgs.podman}/bin/podman pod create fweedee";
    };
    path = [pkgs.zfs pkgs.podman];
  };

  # create container dirs
  system.activationScripts = {
    #
    # probably not required but here for shits n' gigs
    "make${dir}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${dir}'';

    # shared
    "makeshareddir" = lib.stringAfter ["var"] ''mkdir -v -p ${shared.log} ${shared.run} ${shared.config} ${shared.gcodes}'';

    # nginx
    "make${nginx.name}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${nginx.v1} ${nginx.v2}'';

    # moonraker
    "make${moonraker.name}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${moonraker.v1}'';

    # octoprint
    "make${octoprint.name}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${octoprint.dir}'';

    # write printer config from tree to dir
    environment.etc."${shared.config}/printer.cfg" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./printer.cfg;
    };
    # containers
    virtualisation.oci-containers.containers = {
      #
      ${nginx.name} = {
        hostname = "${nginx.name}";
        autoStart = true;
        image = "${nginx.image}";

        volumes = [
          "${time}"

          "${nginx.v1}:/data"
          "${nginx.v2}:/etc/letsencrypt"
        ];

        extraOptions = [
          "--network=macvlan_lan"
          "--ip=${nginx.ip}" # declared above / in secrets
          "--pod=fweedee" # add container to pod
        ];
      };
      #
      ${klipper.name} = {
        hostname = "${klipper.name}";
        autoStart = true;
        image = "${klipper.image}";
        volumes = [
          "${time}"

          "/dev:/dev"
          "${shared.config}:/opt/printer_data/config"
          "${shared.gcodes}:/opt/printer_data/gcodes"
          "${shared.logs}:/opt/printer_data/logs"
          "${shared.run}:/opt/printer_data/run"
        ];

        cmd = [
          "-I printer_data/run/klipper.tty"
          "-a printer_data/run/klipper.sock"
          "printer_data/config/printer.cfg"
          "-l printer_data/logs/klippy.log"
        ];

        extraOptions = [
          "--privileged"
          "--pod=fweedee"
        ];
      };
      #
      ${moonraker.name} = {
        hostname = "${moonraker.name}";
        autoStart = true;
        image = "${moonraker.image}";

        volumes = [
          "${time}"

          "/dev/null:/opt/klipper/config/null"
          "/dev/null:/opt/klipper/docs/null"
          "/run/dbus:/run/dbus"
          "/run/systemd:/run/systemd"

          "${moonraker.db}:/opt/printer_data/database"

          "${shared.config}:/opt/printer_data/config"
          "${shared.gcodes}:/opt/printer_data/gcodes"
          "${shared.logs}:/opt/printer_data/logs"
          "${shared.run}:/opt/printer_data/run"
        ];

        extraOptions = [
          "--privileged"
          "--pod=fweedee"
        ];
      };
      ${fluidd.name} = {
        hostname = "${fluidd.name}";
        autoStart = true;
        image = "${fluidd.image}";
        volumes = ["${time}"];
      };
      ${mainsail.name} = {
        hostname = "${mainsail.name}";
        autoStart = true;
        image = "${mainsail.image}";
        volumes = ["${time}"];
      };
    };
  };
}
/*
# wanting to test out this vs activationScripts
systemd.tmpfiles.rules = [
  "d ${toString dir} 0770 1000 1000 -" # not needed? since this is recursive?
  "d -"
];
*/

