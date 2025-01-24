{pkgs, ...}: {
  boot = {
    # pinning kernel version due to zfs being out of tree & not supporting latest kernel
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod.override {
      argsOverride = rec {
        suffix = "xanmod1";
        version = "6.6.63";
        modDirVersion = "${version}-${suffix}";

        src = pkgs.fetchFromGitLab {
          owner = "xanmod";
          repo = "linux";
          rev = "${version}-${suffix}";
          hash = "sha256-P4B6r3p+Buu1Hf+RQsw5h2oUANVvQvQ4e/2gQcZ0vKw=";
        };
      };
    });

    kernelModules = ["kvm-intel"];
    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];

    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    initrd.kernelModules = ["dm-snapshot"];
    initrd.systemd.enable = true;

    extraModulePackages = [];

    supportedFilesystems = ["zfs" "ntfs"];

    zfs.forceImportRoot = false;
    zfs.extraPools = [
      #TODO
    ];

    loader = {
      grub = {
        enable = true;
        device = "/dev/nvme0n1";
        useOSProber = true;
      };
    };
  };
}
