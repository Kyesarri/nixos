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
        "--device=/dev/ttyUSB0"
        "--ip=${secrets.ip.haos}"
        "--privileged"
      ];
    };
  };
}
