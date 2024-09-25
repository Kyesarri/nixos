{pkgs, ...}: {
  boot = {
    extraModulePackages = [];
    supportedFilesystems = ["ntfs"];

    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelModules = ["kvm-intel"];
    kernelParams = ["nowatchdog"];

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

    loader = {
      systemd-boot = {
        efi.canTouchEfiVariables = true;
        enable = true;
        editor = false;
        memtest86.enable = true;
      };
    };
  };
}
