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
    # believe there were issues with suspend / hibernate on this "laptop"
    # this resolved those issues however this device is "always-on" now
    # or, this would forbid programs from turning-off the "laptop
    # feel the latter is true, wish i wrote this shit down :D
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

    pam.services = {gdm.enableGnomeKeyring = true;}; # unlock keyring with gdm / gdm support for keyring
  };

  nix = {
    sshServe.enable = true; # enable ssh server
    package = pkgs.nixUnstable; # prefer nixunstable over stable
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

    kernelParams = [
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

  # magic language wizzard show
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

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [3389]; # rdp
    };
  };

  services = {
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gnome.gnome-keyring.enable = true; # keyboi
    gvfs.enable = true; # gnome trash support
    printing.enable = false; # cpus printer thingy
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };
    xserver = {
      enable = false; # headless, see how many issues this causes wtih pcie passthrough
      /*
        displayManager.gdm = {
        enable = true;
        wayland = true;
      };
      */
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
    extraGroups = ["networkmanager" "wheel" "docker" "apex"];
    packages = with pkgs; [
      fet-sh # minimal fetch script
      gnome.seahorse # key management
      libnotify # notifications
      udiskie # usb mounting
    ];
  };
}
