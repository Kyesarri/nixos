# /etc/nixos/configuration.nix
{ config, pkgs,lib,  ... }:
{

  system.stateVersion = "23.05";

  imports = [
    ./hardware-configuration.nix
    ];

  time.timeZone = "Australia/Melbourne";
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable; # prefer nixUnstable over stable
    settings = {
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
      experimental-features = [ "nix-command" "flakes" ]; # flakes and nixcommand required for config
    }; # settings
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    }; # gc
  }; # nix



  networking = {
    networkmanager.enable = true;
  }; # networking

  hardware = {
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # required for steam
    }; # opengl
  }; # hardware

  services = {
    printing.enable = true;
    gnome.gnome-keyring.enable = true;
    tailscale.enable = true;
    fwupd.enable = true;
    xserver = {
      enable = true;
      layout = "au";
      xkbVariant = "";
      desktopManager = {
        plasma5.enable = true; # kde plasma5, plasma6 when?
        }; # desktopmanager
      displayManager.lightdm = {
        enable = true;
        background = ./nix-wallpaper-nineish-dark-gray.png; # sets lightdm wallpaper
        greeters.slick = { # lightdm greeter "slick"
          enable = true;
          theme.name = "Qogir-Dark";
          draw-user-backgrounds = true;
        }; # greeters.slick
      }; # displayManager.lightdm
    }; # xserver
  }; # services

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use xanmod kernel
    kernelParams =  [  "nowatchdog" ]; # disables watchdog, was causing shutdown issues
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
      busybox
      curl
      wget
    ]; # systemPackages
  }; # environment

}
# /etc/nixos/configuration.nix
