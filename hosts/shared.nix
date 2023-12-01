# ./hosts/shared.nix
## big portion of my programs / packages are installed here, see the end of file
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  system.stateVersion = "24.05";
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
    nvidia.modesetting.enable = true; # should not be in here now, per device
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

  # added virtualisation here, for ios-kvm / windows vm
  #  virtualisation.libvirtd.enable = true;
  #  users.extraUsers.kel.extraGroups = ["libvirtd"];

  boot = {
    #   extraModprobeConfig = '' # used for vms, not required currently
    #     options kvm_intel nested=1
    #     options kvm_intel emulate_invalid_guest_state=0
    #     options kvm ignore_msrs=1
    #   '';
    kernelPackages = pkgs.linuxPackages_xanmod; # use xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
    ]; # majority of these are needed for desktop, laptop and notebook. tsc and cache probably laptop only
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
      # fixes some connection issues with tailscale, could not connect to tailnet or internet outside of home -
      # without this option enabled
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # kdeconnect
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # kdeconnect
      allowedUDPPorts = [41641]; # tailscale
      allowedTCPPorts = [3389]; # rdp
    };
  };

  services.tailscale.useRoutingFeatures = "client"; # set as client for tailscale
  services.fprintd.enable = true;
  services.upower = {
    enable = true; # using upower for battery monitoring, waybar needs some configuration for this too
    percentageCritical = 10; # this should be device specific or a part of ./home
    percentageLow = 15;
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
    steam = {
      # steam should be part of a wider gaming .nix along with its firewall config
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remoteplay
      dedicatedServer.openFirewall = true; # Open ports in the firewall for steam server
    };

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
        remmina # rdp client
        fet-sh # minimalistic fetch script
        gnome-builder # ide / basic boi
        pamixer # cli pulse audio mixer
        pavucontrol # audio control gui
        brightnessctl # brightness control, used in waybar config
        qogir-icon-theme # icons, not sure how to use :) TODO is this needed?
        wl-color-picker # wayland colour picker
        cinnamon.nemo-with-extensions # file manager
        qview # image viewer
        bottom # hot CLI task manager
        gnome.seahorse # key management
        blueberry # bluetooth gui
        shotman # image capture
        hyprpicker # colour picker for wayland TODO waybar button or hypr keybind
        imagemagick # bitmap editor cli
        wl-clipboard # wayland clipboard, replacing copyq currently
        swaylock-effects # lockscreen of sorts
        iwd # wireless network daemon
        iwgtk # replaces network-manager-applet
        slack # needed for work :)
        libnotify # notifications
        wlogout # wayland logout screen, need to spend more time with this
        poweralertd # laptop power notifications
        gimp-with-plugins # gimp, handy to have
        wf-recorder # screen recorder
        mate.mate-calc # calc
        p7zip
        udiskie # usb mounting
        ulauncher # might be replacement for wofi
        nwg-launchers # lockscreen / application launcher utilities
        bitwarden # password manager
        armcord # discord client / chat
        pcsx2 # ps2 emulator
        # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
        # (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
        # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
      ];
    };
  };
}
# ./hosts/shared.nix

