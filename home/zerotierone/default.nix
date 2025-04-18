{secrets, ...}: {
  networking.firewall.allowedUDPPorts = [9993];

  services.zerotierone = {
    enable = true;
    joinNetworks = ["${secrets.zerotier.network1}"];
    localConf = {
      settings = {
        softwareUpdate = "disable";
        primaryPort = "9993";
        portMappingEnabled = "true";
        allowTcpFallbackRelay = "true";
      };
    };
  };
}
