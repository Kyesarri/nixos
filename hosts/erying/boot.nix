{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    kernelParams = [
      # "i915.enable_fbc=1" # iGPU framebuffer compression, nfi if this works
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
