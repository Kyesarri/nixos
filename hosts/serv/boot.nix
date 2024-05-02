{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    supportedFilesystems = ["zfs"]; # add zfs, for storage
    zfs.forceImportRoot = false;
    zfs.extraPools = ["nvmea" "hddb" "hddc" "hddd" "hdde"];
    kernelParams = [
      "i915.enable_fbc=1" # iGPU framebuffer compression, nfi if this works
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];

    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true; # otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = ["nodev"];
      };
    };
  };
}
