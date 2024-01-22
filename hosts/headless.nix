{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  user,
  plymouth_theme,
  ...
}: {
  # TODO start stripping out parts for the headless laptop, is currently built as my ASUS laptop
  # for now to get it off the ground
  # wont be completely "headless" leaving hypr and some basicboi programs installed
  # is the plan of attack, see how this progresses
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true; # unlock keyring with gdm / gdm support for keyring
    swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system TODO swaylock ./home
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
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues
    ];

    plymouth = {
      enable = true;
      theme = "${plymouth_theme}";
      themePackages = [
        (
          pkgs.adi1090x-plymouth-themes.override {
            selected_themes = ["${plymouth_theme}"];
          }
        )
      ];
    };

    # TODO can i with a single value defined in ./flake.nix select the plymouth theme and prevent all other themes from being
    # installed on my system? should save 500mb if i can do so.

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
    printing.enable = true; # need more than this to print afik? http://localhost:631/ for config
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };

    gnome.gnome-keyring.enable = true;

    # TODO should this be pushed to a n o t h e r nix under /home/ for GDM / SDDM or /boot/
    xserver = {
      enable = true;
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
    # key storage?
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    dconf.enable = true;

    zsh = {
      # quite like zsh compared to bash, leaving here for now
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "line"];
      syntaxHighlighting.patterns = {};
      syntaxHighlighting.styles = {"globbing" = "none";};
      promptInit = "info='n host cpu os wm sh n' fet.sh";
      ohMyZsh = {
        enable = true;
        theme = "fino-time";
        plugins = ["sudo" "terraform" "systemadmin" "vi-mode" "colorize"];
      };
    };
  };

  environment = {
    sessionVariables = rec
    {
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
      # lxqt.lxqt-policykit # gui su prompt, would prefer something gtk / themable by nix-colors
    ];
  };

  users.users.${user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${user}";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      ifrextractor-rs
      uefitool
      nix-init # git flake helper
      fet-sh # minimalistic fetch script
      brightnessctl # brightness control, used in waybar TODO laptop / notebook specific not needed as no worky on desktop :)
      cinnamon.nemo-with-extensions # file manager
      qview # image viewer
      gnome.seahorse # key management
      gscreenshot # image capture
      swaylock-effects # lockscreen, TODO needs script for switch to toggle this on lid-close, TODO own /home/* ... why?
      libnotify # notifications
      p7zip # TODO needs a gui
      udiskie # usb mounting
      nwg-launchers # lockscreen / application launcher utilities TODO move to own /home/*
      bitwarden # password manager
      sleek-grub-theme # testing grub themes TODO grub
      adi1090x-plymouth-themes # plymouth themes
      # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
      # (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
      # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
    ];
  };
}
