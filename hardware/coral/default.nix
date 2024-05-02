{
  config,
  pkgs,
  spaghetti,
  ...
}: let
  libedgetpu = config.boot.kernelPackages.callPackage ./libedgetpu.nix {};
  #gasket = config.boot.kernelPackages.callPackage /home/${spaghetti.user}nixos/hardware/coral/gasket.nix {};
in {
  services.udev.packages = [libedgetpu];
  environment.systemPackages = [pkgs.gasket];
  users.groups.plugdev = {};
  #boot.extraModulePackages = [gasket];
}
