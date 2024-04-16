{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  spaghetti,
  ...
}: {
  imports = [./console.nix]; # console colours
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = lib.mkDefault true;

  security = {
    pam.services = {gdm.enableGnomeKeyring = true;}; # unlock keyring with gdm / gdm support for keyring

    # forbid programs from turning-off the "laptop"
    # device is always on, dont want to hibernate
    polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.login1.suspend" ||
              action.id == "org.freedesktop.login1.suspend-multiple-sessions" ||
              action.id == "org.freedesktop.login1.hibernate" ||
              action.id == "org.freedesktop.login1.hibernate-multiple-sessions")
          {
              return polkit.Result.NO;
          }
      });
    '';
  };

  nix = {
    sshServe.enable = true; # enable ssh server
    package = pkgs.nixUnstable; # prefer nixunstable over stable, hi exploits
    gc = {
      automatic = true; # auto nix garbage collection
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    settings = {
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d iirc
      experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    supportedFilesystems = ["zfs"]; # add zfs, for storage
    zfs.forceImportRoot = false; #
    kernelParams = [
      "i915.enable_fbc=1" # iGPU framebuffer compression, nfi if this works
      "intel_iommu=on" # pci device pass-through
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues on laptop, left in cos
    ];

    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true; # otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = ["nodev"];
      };
    };
  };

  # magic language wizard show
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

  fonts = {
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
    fontDir.enable = true;
    packages = with pkgs; [hack-font];
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  users.users.${spaghetti.user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${spaghetti.user}";
    extraGroups = ["networkmanager" "wheel" "apex"]; # wheel is sudo, apex is for coral
    packages = with pkgs; [
      fet-sh # minimal fetch script
      gnome.seahorse # key management
      libnotify # notifications might not be needed on headless lol
      udiskie # usb mounting, probs for the best atm
    ];
  };
}
