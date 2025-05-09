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

    initrd.systemd.enable = true;

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
