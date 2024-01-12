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
    hostAddress = "192.168.87.9"; # host os
    localAddress = "192.168.87.9"; # container
    #hostAddress6 = "fc00::1";
    #localAddress6 = "fc00::2";

    config = {
      config,
      pkgs,
      ...
    }: {
      services.nextcloud = {
        enable = true;
        package = pkgs.nextcloud28;
        hostName = "localhost";
        config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
      };

      system.stateVersion = "23.11";

      networking = {
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
