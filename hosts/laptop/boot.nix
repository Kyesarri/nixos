{pkgs, ...}: {
  boot = {
    extraModulePackages = [];
    supportedFilesystems = ["ntfs"];

    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use mainline xanmod kernel
    kernelModules = ["kvm-amd" "coretemp"];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = [];

    kernelParams = [
      "amd_pstate=active"
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues, hasn't yet
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
    ];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        memtest86.enable = true;
      };
    };
  };
}
