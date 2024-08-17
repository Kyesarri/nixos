{
  lib,
  secrets,
  ...
}: let
  netbird = {
    dir = "/etc/oci.cont/netbird";
    time = "/etc/localtime:/etc/localtime:ro";

    dash = {
      ip = "${toString secrets.ip.netbird.dash}";
      dir = "/etc/oci.cont/netbird/dash";
      name = "netbird-dash";
      image = "netbirdio/dashboard:latest";
      volume = "/etc/letsencrypt";
    };

    signal = {
      ip = "${toString secrets.ip.netbird.signal}";
      dir = "/etc/oci.cont/netbird/signal";
      name = "netbird-signal";
      image = "netbirdio/signal:latest";
      volume = "/var/lib/netbird";
    };

    manage = {
      ip = "${toString secrets.ip.netbird.manage}";
      dir = "/etc/oci.cont/netbird/manage";
      name = "netbird-manage";
      image = "netbirdio/management:latest";
      volume = "/var/lib/netbird";
    };

    coturn = {
      ip = "${toString secrets.ip.netbird.coturn}";
      dir = "/etc/oci.cont/netbird/coturn";
      name = "netbird-coturn";
      image = "coturn/coturn:latest";
      volume = "/etc/turnserver.conf";
    };
  };
in {
  # create directories in /etc/...
  system.activationScripts = {
    "make${netbird.dir}" =
      lib.stringAfter ["var"]
      ''mkdir -v -p ${toString netbird.dir} ${toString netbird.dash.dir} ${toString netbird.signal.dir} ${toString netbird.manage.dir} ${toString netbird.coturn.dir}'';
  };

  virtualisation.oci-containers.containers = {
    # netbird-dash
    "${netbird.dash.name}" = {
      hostname = "${netbird.dash.name}";
      autoStart = true;
      image = "${netbird.dash.image}";
      volumes = [
        "${toString netbird.time}"
        "${toString netbird.dash.dir}:${toString netbird.dash.volume}"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${netbird.dash.ip}"];
    };
    # netbird-signal
    "${netbird.signal.name}" = {
      hostname = "${netbird.signal.name}";
      autoStart = true;
      image = "${netbird.signal.image}";
      volumes = [
        "${toString netbird.time}"
        "${toString netbird.signal.dir}:${toString netbird.signal.volume}"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${netbird.signal.ip}"];
    };
    # netbird-manage
    "${netbird.manage.name}" = {
      hostname = "${netbird.manage.name}";
      autoStart = true;
      image = "${netbird.manage.image}";
      volumes = [
        "${toString netbird.time}"
        "${toString netbird.dash.dir}:${toString netbird.dash.volume}:ro"
        "${toString netbird.manage.dir}:${toString netbird.manage.volume}"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${netbird.manage.ip}"];
    };
    # netbird-coturn
    "${netbird.coturn.name}" = {
      hostname = "${netbird.coturn.name}";
      autoStart = true;
      image = "${netbird.coturn.image}";
      volumes = [
        "${toString netbird.time}"
        # "${toString netbird.coturn.dir}/turnserver.conf:${toString netbird.coturn.volume}:ro"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${netbird.coturn.ip}"];
    };
  };
}
