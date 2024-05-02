{
  config,
  pkgs,
  spaghetti,
  ...
}: let
  libedgetpu = config.boot.kernelPackages.callPackage ./libedgetpu.nix {};
  #gasket = config.boot.kernelPackages.callPackage /home/${spaghetti.user}nixos/hardware/coral/gasket.nix {};
in {
  boot.kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel

  services.udev.packages = [libedgetpu];
  # environment.systemPackages = [pkgs.gasket]; # rm in unstable hense kernel packages
  users.groups.plugdev = {};
  #boot.extraModulePackages = [gasket];
}
