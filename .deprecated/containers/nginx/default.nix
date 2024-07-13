let
  hostName = "nginx";
  webPort = 81;
in
  {
    config,
    pkgs,
    lib,
    ...
  }: {
    networking = {
      firewall.allowedTCPPorts = [webPort];
      nat = {
        enable = true;
        internalInterfaces = ["ve-${hostName}"];
        externalInterface = "br0";
      };
    };
    containers.${hostName} = {
      extraFlags = ["-U"];
      autoStart = true;
      privateNetwork = true;
      hostBridge = "br0";
      localAddress = "192.168.87.1/24";
      config = {
        config,
        pkgs,
        ...
      }: {
        system.stateVersion = "23.11";

        networking = {
          hostName = "${hostName}";
          # interfaces."eth0".useDHCP = true;
          useHostResolvConf = lib.mkForce false;
        };

        services = {
          resolved.enable = true;
          nginx = {
            enable = true;
            recommendedGzipSettings = true;
            recommendedOptimisation = true;
            recommendedProxySettings = true;
            recommendedTlsSettings = true;
          };
        };
      };
    };
  }
/*
forwardPorts = [
  {
    containerPort = webPort;
    hostPort = webPort;
    protocol = "tcp";
  }
];
*/
#

