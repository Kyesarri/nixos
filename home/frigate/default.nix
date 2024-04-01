{
  spaghetti,
  config,
  pkgs,
  ...
}: {
  # make tmpdir for frigate to use, reduce ssd wear
  fileSystems."/tmp/cache" = {
    device = "none";
    fsType = "tmpfs";
    options = ["defaults" "size=1G" "mode=755"];
  };

  # enable docker
  virtualisation.docker = {
    enable = true;
  };

  home-manager.users.${spaghetti.user} = {
    # docker compose.yml
    home.file.".docker/nvr/compose.yml" = {
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
              - /home/${spaghetti.user}/.docker/nvr/config.yml:/config/config.yml
              - /home/${spaghetti.user}/.docker/nvr:/media/frigate
              - /home/${spaghetti.user}/.docker/nvr:/db
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
    home.file.".docker/nvr/config/" = {
      source = ./config; # symlink ~/nixos/home/frigate/config dir (1 file atm)
      recursive = true; # to ~/.docker/nvr/config/
    };
  };
}
