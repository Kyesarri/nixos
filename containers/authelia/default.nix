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
      localAddress = "192.168.87.7/24";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";
        services.resolved.enable = true;
        networking.defaultGateway = "192.168.87.251";
        useHostResolvConf = lib.mkForce false;
        networking.firewall = {
          enable = true;
          allowedTCPPorts = [webPort];
        };
        services.authelia = {
          enable = true;
          instances = {
            main = {
              enable = true;
              secrets.storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
              secrets.jwtSecretFile = "/etc/authelia/jwtSecretFile";
              settings = {
                theme = "light";
                default_2fa_method = "totp";
                log.level = "debug";
                server.disable_healthcheck = true;
              };
            };
            preprod = {
              enable = false;
              secrets.storageEncryptionKeyFile = "/mnt/pre-prod/authelia/storageEncryptionKeyFile";
              secrets.jwtSecretFile = "/mnt/pre-prod/jwtSecretFile";
              settings = {
                theme = "dark";
                default_2fa_method = "webauthn";
                server.host = "0.0.0.0";
              };
            };
            test.enable = true;
            test.secrets.manual = true;
            test.settings.theme = "grey";
            test.settings.server.disable_healthcheck = true;
            test.settingsFiles = ["/mnt/test/authelia" "/mnt/test-authelia.conf"];
          };
        };
      };
    };
  }
