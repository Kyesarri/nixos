{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use mainline xanmod kernel

    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop
    ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = "1"; # for tailscale exit node
      "net.ipv6.conf.all.forwarding" = "1"; # for tailscale exit node
    };

    initrd = {
      systemd.enable = true;
      availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" "sr_mod" "rtsx_pci_sdmmc"];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
