{
  config,
  pkgs,
  spaghetti,
  ...
}: let
  libedgetpu = config.boot.kernelPackages.callPackage ./libedgetpu.nix {};
  #gasket = config.boot.kernelPackages.callPackage /home/${spaghetti.user}nixos/hardware/coral/gasket.nix {};
in {
  boot.extraModulePackages = [pkgs.linuxKernel.packages.linux_xanmod.gasket];
  services.udev.packages = [libedgetpu];
  # environment.systemPackages = [pkgs.gasket]; # rm in unstable hense kernel packages
  users.groups.plugdev = {};
  #boot.extraModulePackages = [gasket];
}
