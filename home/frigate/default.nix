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

  # enable docker
  virtualisation.docker = {enable = true;};

  # adds docker-compose to system packages
  environment.systemPackages = with pkgs; [docker-compose];

  # adds user to docker group
  # users.user.${spaghetti.user}.extraGroups = ["docker"];
  # may not need this :D

  home-manager.users.${spaghetti.user} = {
    # docker compose.yml
    # can use virtualisation.oci-containers too
    home.file.".docker/frigate/compose.yml" = {
      text = ''
        version: "3.9"
        services:
          frigate: # https://docs.frigate.video/frigate/installation
            container_name: frigate
            privileged: true # needed? to pass-thru hardware (usb? gpu)
            restart: always # why not?
            image: ghcr.io/blakeblackshear/frigate:stable
            shm_size: "128mb" # update for your cameras see installation link above
            devices:
              # - /dev/apex_0:/dev/apex_0 # passes a PCIe Coral, follow driver instructions here https://coral.ai/docs/m2/get-started/#2a-on-linux
              - /dev/dri/renderD128 # for intel hwaccel
            volumes:
            # think this should get some spaghetti, add usernames, other vars
              - /etc/localtime:/etc/localtime:ro
              - /home/${spaghetti.user}/.docker/frigate/config.yml:/config/config.yml
              - /home/${spaghetti.user}/.docker/frigate:/media/frigate
              - /home/${spaghetti.user}/.docker/frigate:/db
              - type: tmpfs # Optional: 1GB of memory, reduces SSD/SD Card wear
                target: /tmp/cache
                tmpfs:
                  size: 1000000000
            ports:
              - "5000:5000"
              - "8554:8554" # RTSP feeds
              - "8555:8555/tcp" # WebRTC over tcp
              - "8555:8555/udp" # WebRTC over udp
      '';
    };
    # frigate config.yml
    home.file.".docker/frigate/config.yml" = {
      source = ./config.yml; # symlink ~/nixos/home/frigate/config.yml
      recursive = true; # to ~/.docker/frigate/config/
    };
  };
}
