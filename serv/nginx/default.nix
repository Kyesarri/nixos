{
  config,
  lib,
  pkgs,
  spaghetti,
  ...
}: {
  users.groups.nginx = {};

  users.extraUsers.nginx = {
    extraGroups = ["wheel"];
    group = "nginx";
    isNormalUser = false;
    # uid = 999;
  };
  services.nginx = {
    enable = true;

    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = {
      "nginx.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:81";};
      };

      "radarr.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:7878";};
      };

      "sonarr.home" = {
        addSSL = false;
        enableACME = false;
        locations."/" = {proxyPass = "http://localhost:8989";};
      };
    };
  };
}
