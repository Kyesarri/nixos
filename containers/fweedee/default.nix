# Auto-generated using compose2nix v0.2.3.
{
  pkgs,
  lib,
  ...
}: {
  # Containers
  virtualisation.oci-containers.containers."fweedee-init" = {
    image = "busybox:latest";
    volumes = [
      "/home/kel/c2n:/prind:rw"
    ];
    cmd = ["chown" "-R" "1000:1000" "/prind/config"];
    labels = {
      "org.prind.service" = "init";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=init"
      "--network=fweedee_default"
    ];
  };
  systemd.services."podman-fweedee-init" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "no";
    };
    after = [
      "podman-network-fweedee_default.service"
    ];
    requires = [
      "podman-network-fweedee_default.service"
    ];
    partOf = [
      "podman-compose-fweedee-root.target"
    ];
    wantedBy = [
      "podman-compose-fweedee-root.target"
    ];
  };
  virtualisation.oci-containers.containers."fweedee-klipper" = {
    image = "mkuf/klipper:latest";
    volumes = [
      "/dev:/dev:rw"
      "/home/kel/c2n/config:/opt/printer_data/config:rw"
      "fweedee_gcode:/opt/printer_data/gcodes:rw"
      "fweedee_log:/opt/printer_data/logs:rw"
      "fweedee_run:/opt/printer_data/run:rw"
    ];
    cmd = ["-I" "printer_data/run/klipper.tty" "-a" "printer_data/run/klipper.sock" "printer_data/config/printer.cfg" "-l" "printer_data/logs/klippy.log"];
    labels = {
      "org.prind.service" = "klipper";
    };
    dependsOn = [
      "fweedee-init"
    ];
    log-driver = "none";
    extraOptions = [
      "--network-alias=klipper"
      "--network=fweedee_default"
      "--privileged"
    ];
  };
  systemd.services."podman-fweedee-klipper" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-fweedee_default.service"
      "podman-volume-fweedee_gcode.service"
      "podman-volume-fweedee_log.service"
      "podman-volume-fweedee_run.service"
    ];
    requires = [
      "podman-network-fweedee_default.service"
      "podman-volume-fweedee_gcode.service"
      "podman-volume-fweedee_log.service"
      "podman-volume-fweedee_run.service"
    ];
    partOf = [
      "podman-compose-fweedee-root.target"
    ];
    wantedBy = [
      "podman-compose-fweedee-root.target"
    ];
  };
  virtualisation.oci-containers.containers."fweedee-traefik" = {
    image = "traefik:3.2";
    volumes = [
      "/var/run/docker.sock:/var/run/docker.sock:ro"
    ];
    ports = [
      "80:80/tcp"
    ];
    cmd = ["--accesslog" "--providers.docker=true" "--providers.docker.exposedbydefault=false" "--entrypoints.web.address=:80"];
    labels = {
      "org.prind.service" = "traefik";
    };
    log-driver = "journald";
    extraOptions = [
      "--network-alias=traefik"
      "--network=fweedee_default"
    ];
  };
  systemd.services."podman-fweedee-traefik" = {
    serviceConfig = {
      Restart = lib.mkOverride 500 "always";
    };
    after = [
      "podman-network-fweedee_default.service"
    ];
    requires = [
      "podman-network-fweedee_default.service"
    ];
    partOf = [
      "podman-compose-fweedee-root.target"
    ];
    wantedBy = [
      "podman-compose-fweedee-root.target"
    ];
  };

  # Networks
  systemd.services."podman-network-fweedee_default" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "podman network rm -f fweedee_default";
    };
    script = ''
      podman network inspect fweedee_default || podman network create fweedee_default
    '';
    partOf = ["podman-compose-fweedee-root.target"];
    wantedBy = ["podman-compose-fweedee-root.target"];
  };

  # Volumes
  systemd.services."podman-volume-fweedee_gcode" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect fweedee_gcode || podman volume create fweedee_gcode
    '';
    partOf = ["podman-compose-fweedee-root.target"];
    wantedBy = ["podman-compose-fweedee-root.target"];
  };
  systemd.services."podman-volume-fweedee_log" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect fweedee_log || podman volume create fweedee_log --opt=device=tmpfs --opt=type=tmpfs
    '';
    partOf = ["podman-compose-fweedee-root.target"];
    wantedBy = ["podman-compose-fweedee-root.target"];
  };
  systemd.services."podman-volume-fweedee_run" = {
    path = [pkgs.podman];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      podman volume inspect fweedee_run || podman volume create fweedee_run --opt=device=tmpfs --opt=type=tmpfs
    '';
    partOf = ["podman-compose-fweedee-root.target"];
    wantedBy = ["podman-compose-fweedee-root.target"];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."podman-compose-fweedee-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = ["multi-user.target"];
  };
}
