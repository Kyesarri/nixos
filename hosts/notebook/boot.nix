{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues, hasn't yet
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
