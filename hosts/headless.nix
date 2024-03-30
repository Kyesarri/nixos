{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  spaghetti,
  ...
}: {
  # TODO start stripping out parts for the headless laptop, is currently built as my ASUS laptop
  # for now to get it off the ground
  # wont be completely "headless" leaving hypr and some basicboi programs installed
  # is the plan of attack, see how this progresses
  imports = [./console.nix]; # console colours
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;

  security = {
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
    pam.services = {
      gdm.enableGnomeKeyring = true; # unlock keyring with gdm / gdm support for keyring
      swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system TODO swaylock ./home
    };
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
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
      experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
    };
  };

  hardware = {
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
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

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues
    ];

    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true; # Otherwise /boot/EFI/BOOT/BOOTX64.EFI isn't generated
        devices = ["nodev"];
        theme = pkgs.sleek-grub-theme; # how to get dark theme?
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

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [3389]; # rdp
    };
  };

  services = {
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gvfs.enable = true; # gnome trash support
    printing.enable = false;
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };

    gnome.gnome-keyring.enable = true;

    # TODO should this be pushed to a n o t h e r nix under /home/ for GDM / SDDM or /boot/
    xserver = {
      enable = false;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  fonts = {
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
    fontDir.enable = true;
    packages = with pkgs; [
      hack-font
      (nerdfonts.override {fonts = ["Iosevka" "CascadiaCode" "JetBrainsMono"];})
    ];
  };

  programs = {
    dconf.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  environment = {
    sessionVariables = rec
    {
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland... why do i use electron?
    };

    shells = with pkgs; [zsh]; # default shell to zsh
    systemPackages = with pkgs; [
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
      gitAndTools.gitFull
      polkit_gnome
      waypipe
    ];
  };

  users.users.${spaghetti.user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${spaghetti.user}";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      fet-sh # minimalistic fetch script
      gnome.seahorse # key management
      libnotify # notifications
      p7zip # TODO needs a gui
      udiskie # usb mounting
      bitwarden # password manager
      sleek-grub-theme # testing grub themes TODO grub
    ];
  };
}
