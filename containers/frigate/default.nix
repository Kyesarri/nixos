{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  # make tmpdir for frigate to use, ssd wear bla bla
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  networking.firewall.allowedTCPPorts = [5000 8554 8555];
  networking.firewall.allowedUDPPorts = [5000 8555];

  virtualisation.oci-containers.containers = {
    #
    frigate = {
      hostname = "frigate-nix-serv";
      autoStart = true;
      image = "ghcr.io/blakeblackshear/frigate:stable";
      ports = [
        # hostPort:containerPort
        "5000:5000" # webui
        "1935:1935" #
        "8554:8554" # rtsp
        "8555:8555/tcp" # webrtc
        "8555:8555/udp" # webrtc
      ];
      # environmentFiles = [ ../secrets/frigate.env ]; # TODO
      volumes = [
        "/home/${spaghetti.user}/.docker/frigate:/db"
        "/home/${spaghetti.user}/.docker/frigate:/media/frigate"
        "/home/${spaghetti.user}/.docker/frigate/config.yml:/config/config.yml:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      extraOptions = [
        "--shm-size=256m"
        # "--device=/dev/apex_0:/dev/apex_0" # enable if using coral in frigate
        "--device=/dev/dri/renderD128" # gpu
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
        "--pull=always" # always want a good pull
      ];
    };
  };
  #
  home-manager.users.${spaghetti.user} = {
    # frigate config.yml symlink, easier to edit in codium as a .yml vs pure nix
    # will move to text = '' ''; soon
    home.file.".docker/frigate/config.yml" = {
      source = ./config.yml;
    };
  };
}
