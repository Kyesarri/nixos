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
    name = mkOption {
      type = types.string;
      default = "";
    };
    isServer = mkOption {
      #TODO
      type = types.bool;
      default = false;
    };
  };

  config = mkMerge [
    (mkIf (cfg.nebula.enable == true) {
      services.nebula.networks.${cfg.name} = {
        enable = true;
        ca = "/home/users/kel/.nebula/ca.crt";
        cert = "/home/users/kel/.nebula/laptop.crt";
        key = "/home/users/kel/.nebula/laptop.key";
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
