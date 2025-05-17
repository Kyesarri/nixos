{secrets, ...}: {
  networking.firewall.allowedUDPPorts = [9993];
  /*
  TODO
  use age secret to write custom planet to /var/lib/zerotier-one/
  */

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
