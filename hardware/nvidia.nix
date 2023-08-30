# /etc/nixos/hardware/nvidia.nix
{ config, pkgs, lib,  ... }:

{

  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest; 
    }; # nvidia
  }; # hardware

}
# /etc/nixos/hardware/nvidia.nix
