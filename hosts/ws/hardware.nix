{
  lib,
  # pkgs,
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
    pulseaudio.enable = false;

    enableRedistributableFirmware = lib.mkDefault true;

    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    sensor.hddtemp = {
      enable = true;
      unit = "C";
      drives = [
        # TODO
      ];
    };

    graphics = {
      enable = true;
      extraPackages = [];
    };
  };

  fileSystems = {
    #TODO
    /*
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
    */
  };

  swapDevices = [
    {
      device = "";
      /*
      "/dev/disk/by-uuid/31007c77-40ea-4c3c-b5a7-08db63f333d8"
      */
    }
  ];
}
