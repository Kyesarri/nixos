{pkgs, ...}: {
  boot = {
    extraModulePackages = [];
    supportedFilesystems = ["ntfs"];
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["kvm-intel"];
    kernelParams = ["nowatchdog"];

    initrd = {
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };

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
