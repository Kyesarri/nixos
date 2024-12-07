{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot.initrd.luks.devices."luks-af8043f2-b67e-45e0-8573-8a8d98a35d45".device = "/dev/disk/by-uuid/af8043f2-b67e-45e0-8573-8a8d98a35d45";

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/0fe7004c-4d8f-4011-8b1a-8611cbf17e3a";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/19F4-5D92";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [];
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
