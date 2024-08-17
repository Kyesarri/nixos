{
  lib,
  secrets,
  ...
}: let
  dir = "/etc/oci.cont/netbird";
  time = "/etc/localtime:/etc/localtime:ro";

  dash = {
    ip = "${toString secrets.ip.netbird.dash}";
    dir = "${toString dir}/dash";
    name = "netbird-dash";
    image = "netbirdio/dashboard:latest";
    volume = "/etc/letsencrypt";
  };

  signal = {
    ip = "${toString secrets.ip.netbird.signal}";
    dir = "${toString dir}/signal";
    name = "netbird-signal";
    image = "netbirdio/signal:latest";
    volume = "/var/lib/netbird";
  };

  manage = {
    ip = "${toString secrets.ip.netbird.manage}";
    dir = "${toString dir}/manage";
    name = "netbird-manage";
    image = "netbirdio/management:latest";
    volume = "/var/lib/netbird";
  };

  coturn = {
    ip = "${toString secrets.ip.netbird.coturn}";
    dir = "${toString dir}/coturn";
    name = "netbird-coturn";
    image = "coturn/coturn:latest";
    volume = "/etc/turnserver.conf";
  };
in {
  # create directories in /etc/...
  system.activationScripts = {
    "make${dir}" =
      lib.stringAfter ["var"]
      ''mkdir -v -p ${toString dir} ${toString dash.dir} ${toString signal.dir} ${toString manage.dir} ${toString coturn.dir}'';
  };

  virtualisation.oci-containers.containers = {
    # netbird-dash
    "${dash.name}" = {
      hostname = "${dash.name}";
      autoStart = true;
      image = "${dash.image}";
      volumes = [
        "${toString time}"
        "${toString dash.dir}:${toString dash.volume}"
      ];
      environment = {
        NETBIRD_MGMT_API_ENDPOINT = "${toString manage.ip}:443";
        NETBIRD_MGMT_GRPC_API_ENDPOINT = "${toString manage.ip}";
      };
      extraOptions = ["--network=macvlan_lan" "--ip=${dash.ip}"];
    };
    # netbird-signal
    "${signal.name}" = {
      hostname = "${signal.name}";
      autoStart = true;
      image = "${signal.image}";
      volumes = [
        "${toString time}"
        "${toString signal.dir}:${toString signal.volume}"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${signal.ip}"];
    };
    # netbird-manage
    ## needs management.json configured :)
    "${manage.name}" = {
      hostname = "${manage.name}";
      autoStart = true;
      image = "${manage.image}";
      volumes = [
        "${toString time}"
        "${toString dash.dir}:${toString dash.volume}:ro"
        "${toString manage.dir}:${toString manage.volume}"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${manage.ip}"];
    };
    # netbird-coturn
    # needs turnserver.conf configured :)
    "${coturn.name}" = {
      hostname = "${coturn.name}";
      autoStart = true;
      image = "${coturn.image}";
      volumes = [
        "${toString time}"
        # "${toString coturn.dir}/turnserver.conf:${toString coturn.volume}:ro"
      ];
      extraOptions = ["--network=macvlan_lan" "--ip=${coturn.ip}"];
    };
  };
}
