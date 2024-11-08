{secrets, ...}: {
  containers.moonraker = {
    autoStart = true;
    privateNetwork = false;
    hostAddress = "${secrets.ip.erying}";
    localAddress = "10.231.136.2";

    config = {lib, ...}: {
      system.stateVersion = "23.11";

      services = {
        resolved.enable = true;

        moonraker = {
          enable = true;
          address = "0.0.0.0";
        };

        traefik = {
          enable = true;
          staticConfigOptions = {
            log.level = "DEBUG";
            api = {
              dashboard = true;
            };

            entryPoints.http.address = ":80";
            entryPoints.http.http.redirections = {
              entryPoint.to = "https";
              entryPoint.scheme = "https";
              entryPoint.permanent = true;
            };
            entryPoints.https.address = ":443";
          };
        };
      };

      networking = {
        useHostResolvConf = lib.mkForce false;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 443];
        };
      };
    };
  };
}
