{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi;
in {
  options.gnocchi.nebula = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    #
    networkName = mkOption {
      type = types.str;
      default = "rather-long-nebula-default-network-name";
    };
    #
    hostName = mkOption {
      type = types.str;
      default = "cool-default-hostName";
    };
    #
    userName = mkOption {
      type = types.str;
      default = "usernamegobrrr";
      description = "your username here, used to add nebula-netname and your user to the same group";
    };
    #
    isServer = mkOption {
      type = types.bool;
      default = false;
      description = "enabling will disable defined lighthouses";
    };
    #
    lighthouses = mkOption {
      type = types.str;
      # type = types.listOf types.str;
      default = "";
      description = "";
      example = ''"192.168.1.2"'';
    };
    #
  };
  /*
  so a few things here
  nebula module creates both a user and a group nebula-networkName
  added the user option, adds our user to the nebula-networkName group
  */

  #TODO add activationScript to mkdir and chown / chmod dir for nebula group - read perms
  #TODO add encrypted nebula keys to secrets, have nix place those in correct dir

  config = mkMerge [
    (mkIf (cfg.nebula.enable == true) {
      # add our user to nebula group
      users.users.${cfg.nebula.userName}.extraGroups = ["nebula-${cfg.nebula.networkName}"];

      environment.systemPackages = [pkgs.nebula];

      # setup nebula service for clients
      services.nebula.networks.${cfg.nebula.networkName} = {
        enable = true;
        ca = "/etc/nebula/ca.crt";
        cert = "/etc/nebula/${cfg.nebula.hostName}.crt";
        key = "/etc/nebula/${cfg.nebula.hostName}.key";
        firewall = {
          outbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
          inbound = [
            {
              host = "any";
              port = "any";
              proto = "any";
            }
          ];
        };
      };
    })

    # lighthouse config
    (mkIf (cfg.nebula.isServer == true) {
      services.nebula.networks.${cfg.nebula.networkName} = {
        isLighthouse = true;
      };
    })

    # client lighthouse config
    (mkIf (cfg.nebula.isServer == false) {
      services.nebula.networks.${cfg.nebula.networkName} = {
        lighthouses = ["${cfg.nebula.lighthouses}"];
      };
    })
  ];
}
