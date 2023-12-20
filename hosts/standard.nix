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
    gdm.enableGnomeKeyring = true; # keyring support for gdm login
    swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system TODO swaylock ./home
  };

  nix = {
    sshServe.enable = true;
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
    nvidia.modesetting.enable = true; # TODO should not be in here now, per device
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true; # required for steam
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_xanmod_latest; # use latest xanmod kernel
    kernelParams = [
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
    ]; # TODO tsc and cache laptop only?

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
    gvfs.enable = true; # gnome trash support
    printing.enable = true; # need more than this to print afik?
    fwupd.enable = true; # firmware updater, what was i using this for again? :D
    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };

    gnome.gnome-keyring.enable = true;

    # TODO should this be pushed to a n o t h e r nix under ./home/ for GDM / SDDM or ./boot/
    xserver = {
      enable = true;
      displayManager.gdm = {
        enable = true;
        wayland = true;
      };
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
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    # TODO remote build testing below
    #  ssh.extraConfig = ''
    #    Host remote_host
    #      ProxyCommand ssh -i /root/.ssh/my_key -W remote_host:1221 kel@jump_host
    #      IdentityFile /root/.ssh/my_key
    #      User ubuntu
    #  '';

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
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland... i hope :D
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
      lxqt.lxqt-policykit # graphical su prompt, hacky workaround atm
    ];
  };

  users.users.${user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${user}";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      remmina # rdp client
      fet-sh # minimalistic fetch script
      brightnessctl # brightness control, used in waybar config
      wl-color-picker # wayland colour picker
      cinnamon.nemo-with-extensions # file manager
      qview # image viewer
      bottom # hot CLI task manager / resource monitor
      gnome.seahorse # key management
      shotman # image capture
      hyprpicker # colour picker for wayland TODO fix script
      imagemagick # bitmap editor cli
      swaylock-effects # lockscreen, TODO needs script for switch to toggle this on lid-close, TODO own ./home/*
      slack # work
      libnotify # notifications
      gimp-with-plugins # gimp, handy to have
      wf-recorder # screen recorder
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      nwg-launchers # lockscreen / application launcher utilities TODO move to own ./home/*
      bitwarden # password manager
      armcord # discord wrapper / chat
      sleek-grub-theme # testing grub themes TODO grub
      # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
      # (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
      # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
    ];
  };
}
