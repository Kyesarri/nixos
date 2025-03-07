{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cont.immich;
in {
  options.cont.immich = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "enable immich container";
    };
    #
    privateNetwork = mkOption {
      type = types.nullOr types.str;
      default = "true";
      example = "false";
      description = "use host network (false) or private network (true)";
    };
    #
    macvlanDev = mkOption {
      type = types.nullOr types.str;
      default = "";
      example = "eth1";
      description = "host ethernet device, leave empty for host network";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable == true) {
      #
      containers.immich = {
        autoStart = true;
        privateNetwork = "${cfg.privateNetwork}";
        macvlans = ["${cfg.macvlanDev}"]; # list of strings, may cause issues?
        bindMounts = {};

        allowedDevices = [
          # {
          #   modifier = "rw";
          #   node = "/dev/net/tun";
          # }
        ];

        config = {pkgs, ...}: {
          system.stateVersion = "23.11";

          services = {
            immich = {
              enable = true;
              package = pkgs.immich;
              openFirewall = true;
              port = 3001;
              host = "0.0.0.0";
              redis = {
                enable = true;
                host = "127.0.0.1";
                port = 6379;
              };
            };
          };
        };
      };
    })
  ];
}
