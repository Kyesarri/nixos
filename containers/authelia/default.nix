{
  config,
  pkgs,
  lib,
  ...
}: {
  containers.authelia = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0"; # specify the bridge name
    localAddress = "192.168.87.7/24";
    config = {
      config,
      pkgs,
      ...
    }: {
      services.authelia = {
        enable = true;
      };

      system.stateVersion = "23.11";

      networking = {
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = true;
          allowedTCPPorts = [80];
        };
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
      services.resolved.enable = true;
    };
  };
}
