{
  lib,
  pkgs,
  config,
  spaghetti,
  ...
}:
with lib; let
  libedgetpu = config.boot.kernelPackages.callPackage ./libedgetpu.nix {};
  cfg = config.gnocchi.coral;
in {
  options.gnocchi = {
    coral = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = "true";
      };
    };
  };
  #
  config = mkMerge [
    (mkIf (cfg.coral.enable == true) {
      boot.extraModulePackages = [pkgs.linuxKernel.packages.linux_xanmod.gasket];
      services.udev.packages = [libedgetpu];
      users.groups.plugdev = {};
    })
  ];
}
