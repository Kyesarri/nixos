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
        libvdpau-va-gl
        vaapiVdpau
        intel-ocl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };

  fileSystems = {
    /*
    # 512gb sata ssd
    "/" = {
      device = "/dev/disk/by-partuuid/2d3e834f-563d-453e-a77a-f34a9a3a4e49";
      fsType = "ext4";
      label = "root";
    };
    "/boot" = {
      device = "/dev/disk/by-partuuid/81cf5d25-8a4e-4823-a1fe-197d1eb36493";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
      label = "boot";
    };
    # 1tb nvme
    "/etc/oci.cont" = {
      device = "/dev/disk/by-uuid/2c81efe8-b0bc-4942-92c0-beff70cebca2";
      fsType = "ext4";
      label = "containers";
    };
    # 1tb sata ssd
    "/etc/oci.cont.scratch" = {
      device = "/dev/disk/by-uuid/91b3bbfd-69c6-4081-ab4d-c1a9818be9b4";
      fsType = "ext4";
      label = "scratch";
    };
    # 128gb nvme
    "/etc/oci.cont.nvme" = {
      device = "/dev/disk/by-uuid/49f27562-6797-4094-a12c-60f1e8d2c7f5";
      fsType = "ext4";
      label = "nvmecontainers";
    */

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

    /*

    "/var/lib/containers/storage/overlay-containers/c90dac394ca92813c09d84525aed65a8cf15d0942c71b65897af50fc31b69273/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/25e903be16f475fd166428d16d3f3b1996107c4e1f5fe09ca28fbd83fbe83b4f/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/e86666b31babdc481465e2e947c41b07b90af9d564c9038ac1c4f80357b502bd/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/e05741e668ddf1f5a172f01ec4b2fc3d1565474ad92da2273ab93f530983768b/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/33aacf4ae6e4801365a7a7ce35772624044b34a74b27c96904c9dd283b6cb747/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/b37e48b7554f9e70527cfff9d58cef96c5dbdb92e440c66ac4f73a0dd8b06399/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/97769df749bc6f31820c3aa14eb3e170247199fad5b6767eab1f9c5418bf2e48/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/78937571648c389428cd17f93dc2c2c971086ef718a63804e84bcc85146e0de6/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/9ecb5e9956106b1f9ac53b145805fd66353127ffbb17102c3728c989545bdd35/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/dc733afbf0c07199e2a042f7a4636fb6d6619cc6cbb6d9cbbdaec2e70829adfa/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/50b61a96420537cad302306b60a797c7ca4a3b9f13a36a1801954cbd8ec92b0d/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/f0f2c0672a3d8952cedf2896e52e0fc8b4cd6e2abb1577cce1363bc391bcbc4b/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/77aa4325061f4319c7d7f647715c22132f9d08e3feb5755c646bb18a197ab4a1/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/9e0b7ae6f43e37b7ed5e8bdbf8e98f94fbcf2c4cd75461179ba3d28fe342cb20/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/521de35d4fe28a5b516518faa669c4292d6976c23f11ce4bf7a938a681a41a4e/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/2a94055a3a1e208ad6c8e371a66cb682cb25e781ee8a2557b2cdfc5fd314611d/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/6ca86b38e64fed545c84ad1c667845c80631e5f76be70114295162eea005f359/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/1a94c4100fa61ac40f5b1b9fa61555b9cbe6f973792eb132b32a0e385735aee6/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/cc4844034bdfcdfa3f925ea0bd5649b8682af910843d78e4633bd8f299bd21f8/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/eca4bf8bfd5ae106a24433b27690a95b64c40768dc844cab8b9e35a87136382a/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/5043a0dac1b210830be38825cd6b87c79d48fa4a3c29d007ba816fbc35607810/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/cbe4062f3ae5ce9df96f03c0f2a848df9ac214e68af9bf3229f0a04fcb98a0dc/merged" = {
      device = "overlay";
      fsType = "overlay";
    };
    "/var/lib/containers/storage/overlay-containers/c94ea2c6e9dd754eb10762a641404393aad887e05dd66919dd96f87ce2a4c0be/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/6b46d452e3bd560ea23b770814825fd63c5bb633d8719d477f94a08e9fac03de/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/0e66a7b709baf69ae1f622b1f750047fd1c9390081586d292462d0e87b918851/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/f53268d9cd916e0c728808ffadc8055b732693897b2d6456efc585ccb4d44b49/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/b676657061bbdd39eb24220609a030a2cd4b9a9b26da1de0d2f691fe5eaee192/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/28cf6962dc790baf535a2bf1c344ca493e875b707fec8a9e4d1358e3193554d3/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/2f4d8819ecb774f15a81be19d9184a9a475063ac006e8cb7c78fb9fe5403e122/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/a1903f5ca27d738a212ac6063de24ce7c42704224e1762ba15d180fd6326429f/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/3d116eec9740db11ce68f9c014d19be3ec0c8571d4632f8916edfa9c9bec269f/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/1293c48127bd4b5c9a27a98793197385150b6f97424913d45bc1dd8be98e8698/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/926c0c6ffb5584300f0fc8781904af94b7a5c3b331e38ee03da448dfbf8906e3/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/a08b076be5162dc6df0d25a06c25c90a3d42df9a50db535dbf32b404a7f7d26e/merged" = {
      device = "overlay";
      fsType = "overlay";
    };

    "/var/lib/containers/storage/overlay-containers/86d62ef170b28d14432f9d710010df55aabc7d9d365bfacd0fda9d3a5ef1349b/userdata/shm" = {
      device = "shm";
      fsType = "tmpfs";
    };

    "/var/lib/containers/storage/overlay/7aa136f40adc0b24e336aa819fab651284a2838565fd9301dc4a538650498031/merged" = {
      device = "overlay";
      fsType = "overlay";
    };
    */
  };
  #
  swapDevices = [
    {
      device = "/swapfile";
      size = 16 * 1024; # 16GB
    }
  ];
}
