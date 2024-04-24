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
      privateNetwork = true;
      hostAddress = "192.168.87.99";
      localAddress = "192.168.87.2";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.blocky.enable = true;
        networking.hostName = "${hostName}";
        networking.useHostResolvConf = lib.mkForce false;
      };
    };
  }
/*
    systemd.network = {
      enable = true;
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
*/

