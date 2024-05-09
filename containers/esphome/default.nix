{
  virtualisation.oci-containers.containers.esphome-pod = {
    image = "ghcr.io/esphome/esphome";
    autoStart = true;
    volumes = [
      "/var/lib/volumes/esphome/config:/config"
      "/var/lib/volumes/esphome/cache:/cache"
      "/etc/localtime:/etc/localtime:ro"
    ];
    extraOptions = [
      "--network=macvlan_lan"
    ];
  };
}
