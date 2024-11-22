{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop
    ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = "1"; # for tailscale exit node
      "net.ipv6.conf.all.forwarding" = "1"; # for tailscale exit node
    };
    supportedFilesystems = ["zfs"];

    initrd.systemd.enable = true;

    zfs = {
      forceImportRoot = false;
      extraPools = [];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
