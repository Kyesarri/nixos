{pkgs, ...}: {
  boot = {
    initrd.systemd.enable = true;
    kernelPackages = pkgs.linuxPackages_xanmod; # backto mainline
    supportedFilesystems = ["zfs"]; # add zfs
    zfs.forceImportRoot = false;
    zfs.extraPools = []; # add new pools ere'
    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
