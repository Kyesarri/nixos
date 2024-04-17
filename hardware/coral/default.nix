{
  config,
  pkgs,
  spaghetti,
  ...
}: let
  libedgetpu = config.boot.kernelPackages.callPackage /home/${spaghetti.user}nixos/hardware/coral/libedgetpu.nix {};
  gasket = config.boot.kernelPackages.callPackage /home/${spaghetti.user}nixos/hardware/coral/gasket.nix {};
in {
  services.udev.packages = [libedgetpu];
  users.groups.plugdev = {};
  boot.extraModulePackages = [gasket];
}
