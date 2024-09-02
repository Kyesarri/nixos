{lib, ...}: {
  ## currently testing the nextcloud container demo from
  ## https://nixos.wiki/wiki/NixOS_Containers

  containers.nextcloud = {
    autoStart = true;
    config = {pkgs, ...}: {
      system.stateVersion = "23.11";

      services = {
        resolved.enable = true;
        nextcloud = {
          enable = true;
          hostName = "nextcloud";
          extraOptions = {
            redis.port = 8081;
          };
          config.adminpassFile = "${pkgs.writeText "adminpass" "test123"}"; # DON'T DO THIS IN PRODUCTION - the password file will be world-readable in the Nix Store!
        };
      };

      networking = {
        useDHCP = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = ["192.168.87.251"];
        defaultGateway = "192.168.87.251";
        firewall = {
          enable = true;
          allowedTCPPorts = [80 8081];
        };
      };
    };
  };
}
