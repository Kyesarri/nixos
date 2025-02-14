{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi;
in {
  options.gnocchi.nebula = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    isServer = mkOption {
      #TODO
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.nebula.enable == true) {
      services.nebula.networks.test = {
        enable = true;
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
