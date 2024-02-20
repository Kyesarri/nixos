{
  config,
  pkgs,
  lib,
  ...
}: {
  ## currently testing the nextcloud container demo from
  ## https://nixos.wiki/wiki/NixOS_Containers
  ## feels like i can leverage lots of this in /containers/default.nix
  ## and leave per-container config in each /containers/container/default.nix

  ## Below is nextcloud specific config

  containers.authelia = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0"; # Specify the bridge name
    localAddress = "192.168.87.7/24";
    config = {
      config,
      pkgs,
      ...
    }: {
      services.authelia = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = "nextcloud";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
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
