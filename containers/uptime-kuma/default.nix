let
  hostName = "uptime-kuma";
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
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.uptime-kuma.enable = true;
        networking.hostName = "${hostName}";
        networking.useHostResolvConf = lib.mkForce false;
      };
    };
  }
