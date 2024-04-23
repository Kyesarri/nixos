let
  hostName = "blocky";
  webPort = 80;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    containers.${hostName} = {
      autoStart = true;
      networkConfig.MACVLAN = "enp6s0";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.blocky.enable = true;
        networking = {
          hostName = "${hostName}";
          useHostResolvConf = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
        };
        systemd.network = {
          networks."10-mv-enp6s0" = {
            matchConfig.Name = "mv-enp6s0";
            address = ["192.168.87.2/24"];
          };
          netdevs."10-mv-enp6s0" = {
            netdevConfig.Name = "mv-enp6s0";
            netdevConfig.Kind = "veth";
          };
        };
      };
    };
  }
