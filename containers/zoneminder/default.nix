{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.zoneminder = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    localAddress = "192.168.87.7/24";

    config = {
      config,
      pkgs,
      ...
    }: {
      services.zoneminder = {
        enable = true;
        hostName = "zoneminder";
      };

      system.stateVersion = "23.11";

      networking = {
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = true;
          allowedTCPPorts = [80];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      services.resolved.enable = true;
    };
  };
}
