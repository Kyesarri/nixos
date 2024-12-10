{pkgs, ...}: {
  boot = {
    # kernelPackages = pkgs.linuxPackages_xanmod; # use mainline xanmod kernel
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linux_xanmod.override {
      argsOverride = rec {
        modDirVersion = "${version}-${suffix}";
        suffix = "xanmod1";
        version = "6.6.59";

        src = pkgs.fetchFromGitHub {
          owner = "xanmod";
          repo = "linux";
          rev = "${version}-${suffix}";
          hash = "sha256-03c0q4rjdj95hii257q6k9rajj555axyphh8n6was9c36a3xibqn";
        };
      };
    });

    kernelParams = [
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop
    ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = "1"; # for tailscale exit node
      "net.ipv6.conf.all.forwarding" = "1"; # for tailscale exit node
    };

    supportedFilesystems = ["zfs"];

    initrd.systemd.enable = true;

    zfs = {
      forceImportRoot = false;
      extraPools = [];
    };

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };
}
