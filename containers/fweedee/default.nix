# inspo from https://github.com/mkuf/prind
# using container images from prind xoxo
# containers all start - now to configure everything ;)
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}: let
  # config happens here, change values as you desire
  dir = "/etc/oci.cont/fweedee"; # set our root directory for containers
  time = "/etc/localtime:/etc/localtime:ro"; # read only our server time to containers
  prefix = "fweedee";

  shared = {
    logs = "${toString dir}/shared/logs";
    run = "${toString dir}/shared/run";
    config = "${toString dir}/shared/config";
    gcodes = "${toString dir}/shared/gcodes";
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
    db = "${moonraker.dir}";
  };

  octoprint = {
    dir = "${toString dir}/octoprint";
    name = "${prefix}-octoprint";
    image = "octoprint/octoprint:latest";
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
  #
  # create a systemd service to bring up our pod
  systemd.services = {
    "create-${prefix}-backend-pod" = with config.virtualisation.oci-containers; {
      serviceConfig.Type = "oneshot";
      wantedBy = [
        "podman-${klipper.name}.service"
        "podman-${moonraker.name}.service"
        "podman-${octoprint.name}.service"
        "podman-${fluidd.name}.service"
        "podman-${mainsail.name}.service"
      ];
      script = ''
        ${pkgs.podman}/bin/podman pod exists ${prefix}-backend || \
          ${pkgs.podman}/bin/podman pod create -n ${prefix}-backend -p '127.0.0.1:80:80'
      '';
    };
    "create-${prefix}-frontend-pod" = with config.virtualisation.oci-containers; {
      serviceConfig.Type = "oneshot";
      wantedBy = [
        "podman-${klipper.name}.service"
        "podman-${moonraker.name}.service"
        "podman-${octoprint.name}.service"
        "podman-${fluidd.name}.service"
        "podman-${mainsail.name}.service"
      ];
      script = ''
        ${pkgs.podman}/bin/podman pod exists ${prefix}-backend || \
          ${pkgs.podman}/bin/podman pod create -n ${prefix}-frontend'
      '';
    };
  };
  /*
  systemd.services."fweedee" = {
    path = [pkgs.zfs pkgs.podman];

    description = "Start podman '${prefix}' pod";

    # don't start without network-online being up
    wants = ["network-online.target"];
    after = ["network-online.target"];

    # our containers require fweedee pod to be up before they start
    requiredBy = [
      "podman-${klipper.name}.service"
      "podman-${moonraker.name}.service"
      "podman-${octoprint.name}.service"
      "podman-${fluidd.name}.service"
      "podman-${mainsail.name}.service"
    ];

    # unsure, might not be required?
    unitConfig.RequiresMountsFor = "/run/containers";

    # script to run (create the pod)

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.podman}/bin/podman pod create -n ${prefix} -p '127.0.0.1:80:80'";
    };
  };
  */
  # create container dirs
  system.activationScripts = {
    #
    # probably not required but here for shits n' gigs
    "make${dir}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${dir}'';

    # shared
    "makeshareddir" = lib.stringAfter ["var"] ''mkdir -v -p ${shared.logs} ${shared.run} ${shared.config} ${shared.gcodes}'';

    # moonraker
    "make${moonraker.name}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${moonraker.dir}'';

    # octoprint
    "make${octoprint.name}dir" = lib.stringAfter ["var"] ''mkdir -v -p ${octoprint.dir}'';

    # chown dirs
    "make${dir}owner" = lib.stringAfter ["var"] ''chown -R 1000:1000 ${toString dir} && echo pwnd'';
  };
  # configs, from tree to container dirs
  environment.etc = {
    "oci.cont/${prefix}/shared/config/printer.cfg" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./printer.cfg;
    };

    "oci.cont/${prefix}/shared/config/moonraker.conf" = {
      mode = "644";
      uid = 1000;
      gid = 1000;
      source = ./moonraker.conf;
    };
  };
  # containers
  virtualisation.oci-containers.containers = {
    #
    ${klipper.name} = {
      autoStart = true;
      image = "${klipper.image}";

      volumes = [
        "${time}"
        "/dev:/dev"
        "${toString shared.config}:/opt/printer_data/config"
        "${toString shared.gcodes}:/opt/printer_data/gcodes"
        "${toString shared.logs}:/opt/printer_data/logs"
        "${toString shared.run}:/opt/printer_data/run"
      ];

      cmd = [
        "-I"
        "printer_data/run/klipper.tty"
        "-a"
        "printer_data/run/klipper.sock"
        "printer_data/config/printer.cfg"
        "-l"
        "printer_data/logs/klippy.log"
      ];

      extraOptions = [
        "--privileged"
        "--pod=fweedee-backend"
      ];
    };
    #
    ${moonraker.name} = {
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
        "--pod=fweedee-backend"
      ];
    };
    #
    ${octoprint.name} = {
      autoStart = true;
      image = "${octoprint.image}";

      volumes = [
        "${time}"
        "/dev:/dev"
        "${octoprint.dir}:/octoprint"
        "${shared.run}:/opt/printer_data/run"
      ];

      extraOptions = [
        "--privileged"
        "--pod=fweedee-backend"
      ];
    };
    #
    ${fluidd.name} = {
      autoStart = true;
      image = "${fluidd.image}";
      volumes = ["${time}"];
      extraOptions = [
        "--pod=fweedee-backend"
        "--pod=fweedee-frontend"
      ];
    };
    #
    ${mainsail.name} = {
      autoStart = true;
      image = "${mainsail.image}";
      volumes = ["${time}"];
      extraOptions = [
        "--pod=fweedee-backend"
      ];
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

