{secrets, ...}: {
  networking.firewall.allowedTCPPorts = [3001]; # open port on host machine
  #TODO remove above - add macvlan for nspawn

  containers.immich = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "${secrets.ip.erying}";

    bindMounts = {};

    allowedDevices = [
      # {
      #   modifier = "rw";
      #   node = "/dev/net/tun";
      # }
    ];

    config = {pkgs, ...}: {
      system.stateVersion = "23.11";

      services = {
        immich = {
          enable = true;
          package = pkgs.immich;
          openFirewall = true;
          port = 3001;
          host = "0.0.0.0";
          redis = {
            enable = true;
            host = "127.0.0.1";
            port = 6379;
          };
        };
      };
    };
  };
}
