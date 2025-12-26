{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";

  zramSwap = {
    enable = true;
    memoryPercent = 5; # 1.6GB~
    algorithm = "zstd";
  };

  hardware = {
    enableRedistributableFirmware = lib.mkDefault true;

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sensor.hddtemp = {
      enable = true;
      unit = "C";
      drives = [
        # use by uuid lol
        "/dev/disk/by-path/pci-0000:00:17.0-ata-1"
        "/dev/disk/by-path/pci-0000:00:17.0-ata-2"
        "/dev/disk/by-path/pci-0000:00:17.0-ata-3"
        "/dev/disk/by-path/pci-0000:00:17.0-ata-4"

        "/dev/disk/by-path/pci-0000:01:00.0-ata-2"
        "/dev/disk/by-path/pci-0000:01:00.0-ata-3"
        "/dev/disk/by-path/pci-0000:01:00.0-ata-4"
        "/dev/disk/by-path/pci-0000:01:00.0-ata-5"
        "/dev/disk/by-path/pci-0000:01:00.0-ata-6"

        "/dev/disk/by-path/pci-0000:05:00.0-nvme-1"
      ];
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-vaapi-driver
        libvdpau-va-gl
        libva-vdpau-driver
        intel-ocl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/29b03be4-7107-4825-a062-ae8cedfc3001";
      fsType = "ext4";
    };

    "/tmp/cache" = {
      device = "none";
      fsType = "tmpfs";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/84DE-719A";
      fsType = "vfat";
    };

    "/storage" = {
      fsType = "fuse.mergerfs";
      device = "/hdd*"; # i should move their mount point, but whatever...
      options = [
        "cache.files=partial"
        "dropcacheonclose=true"
        "category.create=mfs"
        "minfreespace=30G" # https://trapexit.github.io/mergerfs/latest/config/minfreespace/
        "moveonenospc=true" # https://trapexit.github.io/mergerfs/latest/config/moveonenospc/
      ];
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/31007c77-40ea-4c3c-b5a7-08db63f333d8";}];
}
