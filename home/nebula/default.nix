# https://github.com/diogotcorreia/dotfiles/blob/nixos/modules/services/nebula.nix
# great config, thanks for posting
{
  secrets,
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  #
  inherit (lib) mkEnableOption mkOption types mkIf;
  #
  cfg = config.gnocchi.nebula;
  #
  lighthouses = {"${secrets.nebula.serv}" = ["${secrets.ip.serv-1}:4242"];};
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
  };

  #TODO add encrypted nebula keys to secrets, have nix place those in correct dir

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      # add our user to nebula group
      users.users.${cfg.userName}.extraGroups = ["nebula-${cfg.networkName}"];

      # create nebula dir, chown and chmod perms
      system.activationScripts."make-nebula-${cfg.networkName}-dir" = lib.stringAfter ["var"] ''
        mkdir -v -p /etc/nebula & chown -R 1000:nebula-${cfg.networkName} /etc/nebula & chmod -R g+r /etc/nebula
      '';

      # add nebula to systemPackages
      environment.systemPackages = [pkgs.nebula];

      # setup nebula service for clients
      services.nebula.networks.${cfg.networkName} = {
        enable = true;
        ca = "/etc/nebula/ca.crt";
        cert = "/etc/nebula/${cfg.hostName}.crt";
        key = "/etc/nebula/${cfg.hostName}.key";
        # optionals, if host is not a server, add lighthouses
        lighthouses = lib.lists.optionals (!cfg.isServer) (attrNames lighthouses);
        staticHostMap = lighthouses;
        isLighthouse = cfg.isServer;

        settings = {
          punchy = {
            punch = true;
            respond = true;
          };
          static_map = {
            network = "ip";
          };
          relay = {
            relays = lib.lists.optionals (!cfg.isServer) (builtins.attrNames lighthouses);
            use_relays = !cfg.isServer;
          };
        };

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
  ];
}
