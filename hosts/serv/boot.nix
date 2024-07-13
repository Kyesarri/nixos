{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    supportedFilesystems = ["zfs" "ntfs"];
    zfs.forceImportRoot = false;
    zfs.extraPools = [
      "hdda" # wdc 2tb
      "hddb" # wdc 2tb
      "hddc" # hgst 4tb
      "hddd" # hgst 4tb
      "hdde" # hgst 4tb
      "hddf" # wdc 1tb
      "hddg" # wdc 1tb
      "hddh" # wdc 1tb
      "hddi" # st 2tb
    ];
    kernelParams = [
      # "i915.enable_fbc=1" # iGPU framebuffer compression, nfi if this works
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
