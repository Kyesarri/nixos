let
  hostName = "plex";
in
  {
    spaghetti,
    config,
    pkgs,
    lib,
    ...
  }: {
    # looks to make directories on boot / rebuild - not sure if podman will handle this by itself?
    # don't believe so, this is quite handy xoxo
    system.activationScripts.makePlexDir = lib.stringAfter ["var"] ''
      mkdir -p /home/${spaghetti.user}/.docker/${hostName}
    '';
    networking.firewall.allowedTCPPorts = [32400];

    virtualisation.oci-containers.containers.${hostName} = {
      hostname = "${hostName}-nix-serv";
      autoStart = true;
      image = "lscr.io/linuxserver/plex:latest";
      ports = ["32400:32400"];
      volumes = [
        "/etc/localtime:/etc/localtime:ro"
        # "/etc/timezone:/etc/timezone:ro"

        "/dev/dri:/dev/dri"

        "/hddb/movies:/movies/hddb"
        "/hddc/movies:/movies/hddc"
        "/hddd/movies:/movies/hddd"
        "/hdde/movies:/movies/hdde"

        "/hddb/tv_shows:/tv_shows/hddb"
        "/hddc/tv_shows:/tv_shows/hddc"
        "/hddd/tv_shows:/tv_shows/hddd"
        "/hdde/tv_shows:/tv_shows/hdde"

        "/home/${spaghetti.user}/.docker/${hostName}:/config"
      ];
      environment = {};
      extraOptions = [
        # "--network=host"
        "--privileged"
        # "--network=pod-net"
      ];
    };
  }
