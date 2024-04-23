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

      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.blocky.enable = true;
        networking.hostName = "${hostName}";
      };
    };
  }
