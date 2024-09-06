{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop
    ];

    supportedFilesystems = ["zfs"];

    initrd.systemd.enable = true;

    zfs = {
      forceImportRoot = false;
      extraPools = [];
    };
  };

  loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
}
