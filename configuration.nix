# ./configuration.nix
{ config, pkgs,lib, ... }:
{

  system.stateVersion = "23.05";
  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Melbourne";
  nixpkgs.config.allowUnfree = true;

  imports = [ ./hardware-configuration.nix ];

  nix.package = pkgs.nixUnstable; # prefer nixUnstable over stable

  nix.settings =
  {
    auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
    experimental-features = [ "nix-command" "flakes" ]; # flakes and nixcommand required for config
  };

  nix.gc =
  {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 5d";
  };


  hardware = {
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # required for steam
    };
  };

  services = {
    printing.enable = true;
    gnome.gnome-keyring.enable = true; # saving credentials
    tailscale.enable = true;
    fwupd.enable = true;

    xserver = {
      enable = true;
      layout = "au";
      xkbVariant = "";
      desktopManager.plasma5.enable = true;
#      displayManager.defaultSession = "plasma";
      displayManager.session =
      [
        {
          manage = "desktop";
          name = "plasma5+herbstluftwm+whatever";
          start = ''exec env KDEWM=${pkgs.herbstluftwm}/bin/herbstluftwm ${pkgs.plasma-workspace}/bin/startplasma-x11'';
        }
      ];

      windowManager = {
        herbstluftwm.enable = true;
#        herbstluftwm.configFile = "$HOME/herbstluftwm"; # cant figure this bastard out, tried $HOME/ and ./ paths lives in etc/ however i use /home/kel/nixos for my dots
#                                                        # so unsure if I will continue with that path
        awesome.enable = false;
        bspwm.enable = true;
        exwm.enable = false;
        openbox.enable = false;
        i3.enable = false;
        "2bwm".enable = false;
      };

      displayManager.lightdm = {
        enable = true;
        background = ./nix-wallpaper-nineish-dark-gray.png; # sets lightdm wallpaper
        greeters.slick = { # lightdm greeter "slick"
          enable = true;
          theme.name = "Qogir-Dark";
          draw-user-backgrounds = true;
        };
      };

    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod; # use xanmod kernel
    kernelParams =  [  "nowatchdog" ]; # disables watchdog, was causing shutdown / reboot issues
    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true; 
        efiSupport = true;
        efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = [ "nodev" ];
      };
    };
  };

  environment.systemPackages =[ (import ./theme/Aritim-Dark.nix) ];

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
