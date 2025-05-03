{
  lib,
  config,
  secrets,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/490b75f6-8b4a-482e-886e-063f91141e38";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B149-5578";
      fsType = "vfat";
      options = ["fmask=0077" "dmask=0077"];
    };
  };

  hardware = {
    amdgpu.initrd.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      prime = {
        amdgpuBusId = "PCI:4:0:0";
        nvidiaBusId = "PCI:1:0:0";
        offload.enable = true;
      };
    };
  };
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
