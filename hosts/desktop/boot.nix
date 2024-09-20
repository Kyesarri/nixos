{pkgs, ...}: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "quiet"
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
