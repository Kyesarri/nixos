# /etc/nixos/configuration.nix

{ config, pkgs,lib,  ... }:

{

  imports = [
    ./hardware-configuration.nix
    ];

  # dumping ground for random bits
  time.timeZone = "Australia/Melbourne";
  nixpkgs.config.allowUnfree = true;
  
  nix = {

    package = pkgs.nixUnstable;
    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
    }; # settings
  }; # nix

  networking = {
  
    networkmanager.enable = true;
  }; # networking


  hardware = {

    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # Required for steam
    }; # opengl
  }; # hardware
  
  systemd = {
    services = {
      # workaround for a bug with networking when building with flakes
      NetworkManager-wait-online.enable = lib.mkForce false;
      systemd-networkd-wait-online.enable = lib.mkForce false;
    };
  };

  services = {

    printing.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    xserver = {
      enable = true;
      layout = "au";
      xkbVariant = "";
      desktopManager = {
        plasma5.enable = true;
        }; # desktopmanager

      displayManager.lightdm = {
        enable = true;
        background = /etc/nixos/nix-wallpaper-nineish-dark-gray.png;
        greeters.slick = {
          enable = true;
          theme.name = "Qogir-Dark";
          draw-user-backgrounds = true;
        }; # greeters.slick
      }; # displayManager.lightdm
    }; # xserver
  }; # services    

  boot = {

    kernelPackages = pkgs.linuxPackages_xanmod; # use xanmod kernel
    kernelParams =  [  "nowatchdog" ]; # disables watchdog
    loader = {
      efi = {
        efiSysMountPoint = "/boot";
      }; # efi

      grub = {
        enable = true; 
        efiSupport = true;
        efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = [ "nodev" ];
      }; # grub
    }; # loader
  }; # boot

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
    }; # extraLocaleSettings
  }; # i18n

  environment = {

    systemPackages = with pkgs; [
      lshw
      usbutils
    ]; # systemPackages
  }; # environment
  
  # don't touch this value :)
  system.stateVersion = "23.05";

}
# /etc/nixos/configuration.nix
