let
  hostName = "authelia";
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
      hostBridge = "br0"; # specify the bridge name
      localAddress = "192.168.87.5/24";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.resolved.enable = true;
        networking = {
          defaultGateway = "192.168.87.251";
          useHostResolvConf = lib.mkForce false;
          firewall = {
            enable = true;
            allowedTCPPorts = [webPort];
          };
        };
        services.authelia.instances = {
          main = {
            enable = true;
            secrets.storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
            secrets.jwtSecretFile = "/etc/authelia/jwtSecretFile";
            settings = {
              theme = "dark";
              default_2fa_method = "totp";
              log.level = "debug";
              server.disable_healthcheck = true;
              server.host = "192.168.87.5";
            };
          };
        };
      };
    };
  }
