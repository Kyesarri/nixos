{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use mainline xanmod kernel
    kernelModules = ["kvm-intel"];
    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];

    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    extraModulePackages = [];

    supportedFilesystems = ["zfs" "ntfs"];
    initrd.systemd.enable = true;

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

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
