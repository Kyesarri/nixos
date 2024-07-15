{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
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
