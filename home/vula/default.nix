# https://codeberg.org/vula/vula
#
# With zero configuration, vula automatically encrypts IP communication between hosts
# on a local area network in a forward-secret and transitionally post-quantum manner
# to protect against passive eavesdropping.
{
  spaghetti,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi;
in {
  options.gnocchi.vula = {
    #
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    #
  };

  config = mkMerge [
    (mkIf (cfg.vula.enable == true) {
      #
      services.vula = {
        enable = true;
        openFirewall = true;
      };
      #
      users.users.${spaghetti.user}.extraGroups = [
        "vula-ops"
        "vula"
      ];
      #
    })
  ];
}
