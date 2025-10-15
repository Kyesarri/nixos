{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/f93f9412-52c7-4f05-8f23-438c4044bac6";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/CFE1-D9F6";
    fsType = "vfat";
    options = ["fmask=0077" "dmask=0077"];
  };

  swapDevices = [{device = "/dev/disk/by-uuid/34dbf4e5-2f1e-4677-b7e5-40b811b64605";}];

  services.xserver.enable = true;
  # services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    # testing some options for power saving
    # have a stack of packages currently,
    # corectl, asusd / rog control center, lact
    # amdgpu.initrd.enable = true;
    cpu.amd = {
      # ryzen-smu.enable = true;
      updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };
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
      prime = {
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
      };
    };
  };
}
