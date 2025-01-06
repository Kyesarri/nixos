{
  spaghetti,
  secrets,
  ...
}: let
  contName = "home-assistant";
in {
  virtualisation.oci-containers.containers = {
    home-assistant = {
      hostname = "${contName}";

      autoStart = true;

      image = "home-assistant/home-assistant:latest";

      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        "/home/${spaghetti.user}/.containers/${contName}:/config"
      ];

      environment = {PYTHONPATH = "config/deps";}; # possible fix for issues since last? 24 release

      extraOptions = [
        "--network=macvlan_lan"
        "--ip=${secrets.ip.haos}"
      ];
    };
  };
}
