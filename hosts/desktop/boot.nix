{pkgs, ...}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "quiet" # removes boot messages, testing for plymouth themes, TODO move to plymouth /service/ ?
    ]; # TODO tsc and cache laptop only?

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
/*
loader = {
  systemd-boot.enable = false;
  efi.efiSysMountPoint = "/boot";
  grub = {
    memtest86.enable = true;
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
    devices = ["nodev"];
    theme = pkgs.sleek-grub-theme; # TODO move back to systemd
  };
};
*/

