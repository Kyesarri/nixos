# TODO ./hardware/nvidia/
{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware = {
    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
    };
  };
}
