{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems = {
    #
    "/" = {
      device = "/dev/disk/by-uuid/7f98b95a-b4a3-4a9c-94e8-76d77054fb28";
      fsType = "ext4";
    };
    #
    "/boot" = {
      device = "/dev/disk/by-uuid/3847-FA30";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    #
    "/etc/oci.cont" = {
      device = "/dev/disk/by-uuid/2c81efe8-b0bc-4942-92c0-beff70cebca2";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
