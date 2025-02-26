{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  inherit (lib) mkEnableOption mkOption types mkIf;
  cfg = config.gnocchi;
  lighthouses = {
    "${secrets.nebula.serv}" = ["${secrets.ip.serv-1}:4242"];
  };
in {
  options.gnocchi.nebula = {
    #
    enable = mkEnableOption "nebula";
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
    /*
      lighthouses = mkOption {
      type = types.str;
      # type = types.listOf types.str;
      default = "";
      description = "currently single lighthouse, want to map this as a list of strings somehow :)";
      example = ''"192.168.1.2"'';
    };
    */
    #
  };

  /*
  so a few things here
  nebula module creates both a user and a group nebula-networkName
  added the user option, adds our user to the nebula-networkName group
  */

  #TODO add encrypted nebula keys to secrets, have nix place those in correct dir

  config = mkMerge [
    (mkIf (cfg.nebula.enable == true) {
      #
      # add our user to nebula group
      users.users.${cfg.nebula.userName}.extraGroups = ["nebula-${cfg.nebula.networkName}"];

      # create nebula dir, chown and chmod perms
      system.activationScripts."make-nebula-${cfg.nebula.networkName}-dir" = lib.stringAfter ["var"] ''
        mkdir -v -p /etc/nebula & chown -R 1000:nebula-${cfg.nebula.networkName} /etc/nebula & chmod -R g+r /etc/nebula
      '';

      # add nebula to systemPackages
      environment.systemPackages = [pkgs.nebula];

      # setup nebula service for clients
      services.nebula.networks.${cfg.nebula.networkName} = {
        enable = true;
        ca = "/etc/nebula/ca.crt";
        cert = "/etc/nebula/${cfg.nebula.hostName}.crt";
        key = "/etc/nebula/${cfg.nebula.hostName}.key";
        # uses the let xyz in
        # not sure about optionals
        # ! is not
        # so if the device is not a server do... the things take the atribute names from the value lighthouses
        # defined above
        lighthouses = lib.lists.optionals (!cfg.nebula.isServer) (attrNames lighthouses);
        staticHostMap = lighthouses;
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

    # this is bad, due to one option will always be active despite not wanting to load the module
    # need a mkif x and y are true not the current true or false for one option

    # lighthouse config
    (mkIf (cfg.nebula.isServer == true) {
      services.nebula.networks.${cfg.nebula.networkName} = {
        isLighthouse = true;
      };
    })

    # client lighthouse config
    /*
    (mkIf (cfg.nebula.isServer == false) {
      services.nebula.networks.${cfg.nebula.networkName} = {
      };
    })
    */
  ];
}
