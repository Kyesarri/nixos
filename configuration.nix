# ./configuration.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  system.stateVersion = "23.05";
  time.timeZone = "Australia/Melbourne";
  nixpkgs.config.allowUnfree = true;
  security.pam.services.gdm.enableGnomeKeyring = true; # keyring support for GDM
  security.pam.services.swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  nix.package = pkgs.nixUnstable; # prefer nixunstable over stable

  nix.settings = {
    auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
    experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
  };

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };

  hardware = {
    nvidia.modesetting.enable = true;
    pulseaudio.enable = false;

    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # required for steam
    };
  };

  services = {
    printing.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };
    gnome.gnome-keyring.enable = true;

    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues
      "clocksource=tsc" # not working on laptop, wonder if this is a hardware limitation
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
    ];
    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = ["nodev"];
      };
    };
  };

  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  };
}
# ./configuration.nix

