{
  lib,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/d584a658-8426-47f9-942a-e1d9dd4a9d48";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B47E-9213";
    fsType = "vfat";
  };

  swapDevices = [{device = "/dev/disk/by-uuid/04e81e82-6196-4033-8a41-fe12badd919a";}];

  hardware = {
    pulseaudio.enable = false;
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
