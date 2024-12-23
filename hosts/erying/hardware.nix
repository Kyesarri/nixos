{
  lib,
  pkgs,
  config,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  hardware = {
    cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    enableRedistributableFirmware = lib.mkDefault true;
    pulseaudio.enable = false;

    sensor.hddtemp = {
      enable = true;
      unit = "C";
      drives = [
        "/dev/disk/by-path/pci-0000:00:17.0-ata-1"
        "/dev/disk/by-uuid/pci-0000:00:17.0-ata-2"
        "/dev/disk/by-uuid/pci-0000:02:00.0-nvme-1"
        "/dev/disk/by-uuid/pci-0000:03:00.0-nvme-1"
      ];
    };

    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        vaapiIntel
        vpl-gpu-rt
        libvdpau-va-gl
        vaapiVdpau
        intel-ocl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7f98b95a-b4a3-4a9c-94e8-76d77054fb28";
      fsType = "ext4";
    };

    "/tmp/cache" = {
      device = "none";
      fsType = "tmpfs";
    };

    "/etc/oci.cont.nvme" = {
      device = "/dev/disk/by-uuid/49f27562-6797-4094-a12c-60f1e8d2c7f5";
      fsType = "ext4";
    };

    "/etc/oci.cont" = {
      device = "/dev/disk/by-uuid/2c81efe8-b0bc-4942-92c0-beff70cebca2";
      fsType = "ext4";
    };

    "/etc/oci.cont.scratch" = {
      device = "/dev/disk/by-uuid/91b3bbfd-69c6-4081-ab4d-c1a9818be9b4";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/3847-FA30";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };

    "/var/lib/containers/storage/overlay" = {
      device = "/var/lib/containers/storage/overlay";
      fsType = "none";
      options = ["bind"];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
      size = 4 * 1024; # 4GB
    }
  ];
}
