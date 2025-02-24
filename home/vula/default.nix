# https://codeberg.org/vula/vula
#
# With zero configuration, vula automatically encrypts IP communication between hosts
# on a local area network in a forward-secret and transitionally post-quantum manner
#  to protect against passive eavesdropping.
#
# evaluation warning: The type `types.string` is deprecated. See https://github.com/NixOS/nixpkgs/pull/66346 for better alternative types #fuck
#TODO
{
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
    })
  ];
}
