# ./hosts/minimal.nix
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  user,
  ...
}: {
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true; # keyring support for GDM
    swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system
  };

  nix = {
    package = pkgs.nixUnstable; # prefer nixunstable over stable
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    settings = {
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
      experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
    };
  };

  hardware = {
    pulseaudio.enable = false; # ./hardware/audio
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services = {
    gvfs.enable = true; # gnome trash support
    gnome.gnome-keyring.enable = true;
    printing.enable = false;
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelParams = [];
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

  networking.firewall.enable = true;

  fonts = {
    # remove from minimal? leave one font used by waybar?
    packages = with pkgs; [
      material-design-icons
      inter
      material-symbols
      rubik
      ibm-plex
      nerdfonts
      (nerdfonts.override {fonts = ["Iosevka" "CascadiaCode" "JetBrainsMono"];})
    ];
  };

  programs = {
    dconf.enable = true;
    fish.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    shells = with pkgs; [fish]; # default shell

    sessionVariables = rec
    {
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland, wasn't working for me :)
    };

    systemPackages = with pkgs; [
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
      gitAndTools.gitFull
      lxqt.lxqt-policykit
    ];
  };

  users.users.${user} = {
    isNormalUser = true;
    description = "${user}";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      brightnessctl # brightness control, used in waybar config for laptops only
      wl-color-picker # wayland colour picker
      cinnamon.nemo-with-extensions # file manager
      qview # image viewer
      bottom # hot CLI task manager
      gnome.seahorse # key management
      shotman # image capture
      hyprpicker # colour picker for wayland TODO fix script
      libnotify # notifications
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      bitwarden # password manager
      armcord # discord client / chat
    ];
  };
}
# ./hosts/minimal.nix

