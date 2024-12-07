{pkgs, ...}: {
  boot = {
    extraModulePackages = [];

    initrd.availableKernelModules = ["xhci_pci" "usb_storage" "sd_mod" "sdhci_acpi" "rtsx_usb_sdmmc"];
    initrd.kernelModules = [];

    kernelModules = [];
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues, hasn't yet
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
