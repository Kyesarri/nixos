{
  spaghetti,
  secrets,
  # lib,
  ...
}: let
  contName = "home-assistant";
in {
  virtualisation.oci-containers.containers = {
    home-assistant = {
      hostname = "${contName}";
      autoStart = true;
      image = "ghcr.io/home-assistant/home-assistant:latest";

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.containers/${contName}:/config"
      ];
      environment = {};

      extraOptions = [
        "--network=macvlan_lan"
        "--ip=${secrets.ip.haos}"
      ];
    };
  };
}
