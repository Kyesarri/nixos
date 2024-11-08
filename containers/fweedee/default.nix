{secrets, ...}: {
  containers.moonraker = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "${secrets.ip.erying}";
    localAddress = "192.168.87.88";
    config = {lib, ...}: {
      services.moonraker = {
        enable = true;
        address = "0.0.0.0";
      };
      system.stateVersion = "23.11";
      networking = {
        useHostResolvConf = lib.mkForce false;
        firewall = {
          enable = true;
          allowedTCPPorts = [80 22];
        };
      };
      services.resolved.enable = true;
    };
  };
}
