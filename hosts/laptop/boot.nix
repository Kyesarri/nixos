{pkgs, ...}: {
  boot = {
    extraModulePackages = [];
    supportedFilesystems = ["ntfs" "nfs"];
    kernelPackages = pkgs.linuxPackages_latest;

    kernelModules = ["kvm-amd" "coretemp" "asus-wmi" "asus-armoury"];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
      luks.devices = {
        "luks-6e5b79bf-8bde-4621-a4b4-ffa86ecac959".device = "/dev/disk/by-uuid/6e5b79bf-8bde-4621-a4b4-ffa86ecac959";
        "luks-44695fc4-ecad-4fc2-8332-bfa3c1ce19f3".device = "/dev/disk/by-uuid/44695fc4-ecad-4fc2-8332-bfa3c1ce19f3";
      };
    };

    kernelParams = [
      "amd_pstate=active"
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues, hasn't yet
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
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
