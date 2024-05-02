{
  config,
  pkgs,
  spaghetti,
  ...
}: let
  libedgetpu = config.boot.kernelPackages.callPackage ./libedgetpu.nix {};
in {
  boot.extraModulePackages = [pkgs.linuxKernel.packages.linux_xanmod.gasket];
  services.udev.packages = [libedgetpu];
  users.groups.plugdev = {};
}
