{
  lib,
  config,
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
    # # # # # # # # # #
    # 512gb sata ssd  #
    # v v v v v v v v #
    "/" = {
      device = "/dev/disk/by-uuid/7f98b95a-b4a3-4a9c-94e8-76d77054fb28";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/3847-FA30";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
    # # # # # # #
    # 1tb nvme  #
    # v v v v v #
    "/etc/oci.cont" = {
      device = "/dev/disk/by-uuid/2c81efe8-b0bc-4942-92c0-beff70cebca2";
      fsType = "ext4";
    };
    # # # # # # # # #
    # 1tb sata ssd  #
    # v v v v v v v #
    "/etc/oci.cont.scratch" = {
      device = "/dev/disk/by-uuid/91b3bbfd-69c6-4081-ab4d-c1a9818be9b4";
      fsType = "ext4";
    };
  };
  #
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}
