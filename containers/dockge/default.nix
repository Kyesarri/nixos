{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  networking.firewall = {
    allowedTCPPorts = [5001];
    allowedUDPPorts = [];
  };
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      dockge = {
        hostname = "dockge-nix-serv";
        autoStart = true;
        image = "louislam/dockge:1";
        ports = ["5001:5001"];
        volumes = [
          "/home/${spaghetti.user}/.docker/dockge/data:/app/data"
          "/opt/stacks:/opt/stacks"
          #"var/run/docker.sock:var/run/docker.sock"
          "/etc/localtime:/etc/localtime:ro"
        ];
        environment = {DOCKGE_STACKS_DIR = "/opt/stacks";};
        extraOptions = [
          "--pull=always"
        ];
      };
    };
  };
}
