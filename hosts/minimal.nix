# ./hosts/minimal.nix
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;
  security.pam.services.gdm.enableGnomeKeyring = true; # keyring support for GDM

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
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services = {
    tailscale.useRoutingFeatures = "client"; # set as client for tailscale

    printing.enable = false;
    tailscale.enable = true;
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

  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedUDPPorts = [41641]; # tailscale
    };
  };

  fonts = {
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
    zsh = {
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
      MOZ_ENABLE_WAYLAND = "1";
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland, wasn't working for me :)
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
      lxqt.lxqt-policykit
    ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.kel = {
      isNormalUser = true;
      description = "kel";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        firefox
        tailscale # mah boi
        tailscale-systray
        fet-sh # minimalistic fetch script
        pamixer # cli pulse audio mixer
        pavucontrol # audio control gui
        brightnessctl # brightness control, used in waybar config
        wl-color-picker # wayland colour picker
        cinnamon.nemo-with-extensions # file manager
        qview # image viewer
        bottom # hot CLI task manager
        gnome.seahorse # key management
        blueberry # bluetooth gui
        shotman # image capture
        hyprpicker # colour picker for wayland TODO waybar button or hypr keybind
        wl-clipboard # wayland clipboard, replacing copyq currently
        iwd # wireless network daemon
        iwgtk # replaces network-manager-applet
        libnotify # notifications
        poweralertd # laptop power notifications
        mate.mate-calc # calc
        p7zip # TODO needs a gui
        udiskie # usb mounting
        bitwarden # password manager
        armcord # discord client / chat
      ];
    };
  };
}
# ./hosts/minimal.nix

