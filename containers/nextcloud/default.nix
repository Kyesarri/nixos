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

  containers.nextcloud = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "192.168.87.8";
    # hostBridge = "br0";
    localAddress = "192.168.87.8/24";
    config = {
      config,
      pkgs,
      ...
    }: {
      system.stateVersion = "23.11";

      services = {
        resolved.enable = true;
        nextcloud = {
          enable = true;
          package = pkgs.nextcloud28;
          hostName = "nextcloud";
          config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
        };
      };

      networking = {
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = true;
          allowedTCPPorts = [8082];
        };
        # Use systemd-resolved inside the container
        # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
        useHostResolvConf = lib.mkForce false;
      };
    };
  };
}
