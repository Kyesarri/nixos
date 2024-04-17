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

  networking.firewall = {
    allowedTCPPorts = [5000 8554 8555];
    allowedUDPPorts = [5000 8555];
  };

  # runs as a systemd service
  ## only issue is that GPU monitoring isn't working from inside
  ## the container, but gpu is working
  ### intel-gpu-tools may fix this?
  #### nope :)
  virtualisation.oci-containers.containers = {
    #
    frigate = {
      hostname = "frigate-nix-serv";
      autoStart = true;
      image = "ghcr.io/blakeblackshear/frigate:stable";
      ports = [
        # hostPort:containerPort
        "5000:5000"
        "1935:1935"
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
        # "--device=/dev/apex_0:/dev/apex_0" # dont have coral yet - implement 9900k as nix? yespls
        "--device=/dev/dri/renderD128"
        "--mount=type=tmpfs,target=/tmp/cache,tmpfs-size=1000000000"
        "--pull=always"
      ];
    };
  };
  #
  home-manager.users.${spaghetti.user} = {
    # frigate config.yml symlink, easier to edit in codeium as a .yml vs pure nix
    # will move to text = '' ''; soon
    home.file.".docker/frigate/config.yml" = {
      source = ./config.yml;
    };
  };
}
