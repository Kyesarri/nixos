{pkgs, ...}: {
  boot = {
    loader = {
      timeout = 0;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        memtest86.enable = true;
      };
    };

    consoleLogLevel = 3;

    extraModulePackages = [];

    supportedFilesystems = ["ntfs" "nfs"];

    kernel.sysctl = {
      "vm.vfs_cache_pressure" = 50; # cache tweak, not sure if it does much :D
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelPatches = [
      {
        name = "Rust Support";
        patch = null;
        features.rust = true;
      }
    ];

    kernelModules = ["kvm-amd" "coretemp" "asus-wmi" "asus-armoury"];

    plymouth = {
      enable = true;
      theme = "hexagon_dots";
      themePackages = with pkgs; [(adi1090x-plymouth-themes.override {selected_themes = ["hexagon_dots"];})];
    };

    kernelParams = [
      # amd cpu specific
      "amd_pstate=active"
      "amd_prefcore=enabled"

      # watchdog fixes, system specific
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues, hasn't yet
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop

      # messing with timers
      "highres=on" # 4k timers wew
      "nohz=on" # tickless kernel gosh
      "nohz_full=1-$(nproc)" # tickless mode for all but core 0

      # for cleaner boot output
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=false" # hides systemd status at boot
    ];

    initrd = {
      verbose = false;
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = [];
      systemd.enable = true;
      luks.devices = {
        "luks-6e5b79bf-8bde-4621-a4b4-ffa86ecac959".device = "/dev/disk/by-uuid/6e5b79bf-8bde-4621-a4b4-ffa86ecac959";
        "luks-44695fc4-ecad-4fc2-8332-bfa3c1ce19f3".device = "/dev/disk/by-uuid/44695fc4-ecad-4fc2-8332-bfa3c1ce19f3";
      };
    };
  };
}
