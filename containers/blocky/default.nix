let
  hostName = "blocky";
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
      localAddress = "192.168.87.2/24";
      hostBridge = "enp1s0";
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
