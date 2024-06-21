{...}: {
  users.groups.nginx = {}; # create group nginx

  users.extraUsers.nginx = {
    extraGroups = ["wheel"];
    group = "nginx";
    isNormalUser = false;
  };

  networking.firewall.allowedTCPPorts = [80 81 443];

  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    statusPage = true;

    virtualHosts = {
      "nginx.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:81";};
        serverAliases = [
          "www.nginx.home"
        ];
      };

      "radarr.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:7878";};
        serverAliases = [
          "www.radarr.home"
        ];
      };

      "sonarr.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:8989";};
        serverAliases = [
          "www.sonarr.home"
        ];
      };
      "frigate.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:5000";};
        serverAliases = [
          "www.frigate.home"
        ];
      };
      "plex.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:32400";};
        serverAliases = [
          "www.plex.home"
        ];
      };
    };
  };
}
