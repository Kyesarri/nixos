{pkgs, ...}: {
  boot = {
    # pinning kernel version due to zfs being out of tree & not supporting latest kernel
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod.override {
      argsOverride = rec {
        suffix = "xanmod1";
        version = "6.12.14";
        modDirVersion = "${version}-${suffix}";

        src = pkgs.fetchFromGitLab {
          owner = "xanmod";
          repo = "linux";
          rev = "${version}-${suffix}";
          hash = "sha256-+lkOWfygGbR3vYfwrUvcHrAq00ReqxNsyD1Ar8D1kag=";
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
      "hdda" # wdc 2tb
      "hddb" # wdc 2tb
      "hddc" # hgst 4tb
      "hddd" # hgst 4tb
      "hdde" # hgst 4tb
      "hddf" # wdc 1tb
      "hddg" # wdc 1tb
      "hddh" # wdc 1tb
      "hddi" # st 2tb
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
