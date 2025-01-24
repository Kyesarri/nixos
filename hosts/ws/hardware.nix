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
    "/" = {
      device = "/dev/disk/by-uuid/8e085135-84a7-47b5-9ed5-ad036bd33d56";
      fsType = "ext4";
    };
  };

  swapDevices = [
    {
      device = "/dev/disk/by-uuid/e071a560-b183-4c1e-84df-25dbeafdec48";
    }
  ];
}
