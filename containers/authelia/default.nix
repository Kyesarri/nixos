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
      # hostAddress = "192.168.87.9";
      localAddress = "192.168.87.5/24";
      hostBridge = "br0";
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
        systemd.services.authelia-main.preStart = ''
          [ -f /var/lib/authelia-main/jwt-secret ] || {
            "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/jwt-secret
          }
          [ -f /var/lib/authelia-main/storage-encryption-file ] || {
            "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/storage-encryption-file
          }
          [ -f /var/lib/authelia-main/session-secret-file ] || {
            "${pkgs.openssl}/bin/openssl" rand -base64 32 > /var/lib/authelia-main/session-secret-file
          }
        '';

        services.authelia.instances.main = {
          enable = true;
          name = "${hostName}";
          secrets.storageEncryptionKeyFile = "/etc/authelia/storageEncryptionKeyFile";
          secrets.jwtSecretFile = "/etc/authelia/jwtSecretFile";
          settings = {
            theme = "dark";
            default_2fa_method = "totp";
            log.level = "debug";
            server.disable_healthcheck = true;
            server.host = "192.168.87.5";
            server.port = webPort;
          };
        };
      };
    };
  }
