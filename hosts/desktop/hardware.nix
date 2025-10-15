{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/6fbe0d31-d02f-4c44-a0a2-f527653b130e";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D596-74B1";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/ade95298-b55d-4256-9ce5-e8cb93da19b8";}];

  # powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  services.xserver.enable = true;

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
    };
  };
}
