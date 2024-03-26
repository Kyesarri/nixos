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

  nixpkgs.config.allowUnfree = true;

  security.pam.services = {gdm.enableGnomeKeyring = true;};

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
      "nowatchdog" # disables watchdog, was causing shutdown / reboot issues with wifi
      "clocksource=tsc" # now working with tsc nowatchdog & tsc reliable
      "tsc=nowatchdog" # workaround for check_tsc_sync_source failed, could cause issues
      "tsc=reliable" # flags tsc clock as reliable, workaround to get tsc working on laptop
      "vm.vfs_cache_pressure=50" # cache tweak, not sure if it does much :D
      "quiet" # removes boot messages, testing for plymouth themes, TODO move to plymouth /service/ ?
    ]; # TODO tsc and cache laptop only?

    plymouth = {
      enable = true;
      theme = "${spaghetti.plymouth}";
      themePackages = [(pkgs.adi1090x-plymouth-themes.override {selected_themes = ["${spaghetti.plymouth}"];})];
    };

    # TODO can i with a single value defined in ./flake.nix select the plymouth theme and prevent all other themes from being
    # installed on my system? should save 500mb if i can do so.

    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        memtest86.enable = true;
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

    /*
    # TODO move to gnocchi
    xserver = {
      enable = true;
      displayManager.lightdm = {
        enable = true;
        greeters.slick.enable = true;
      };
    };
    */
  };

  fonts = {
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
    fontDir.enable = true; # lots of fonts here, remove but most often used? not sure what fonts i even use anymore; add to spaghetti
    packages = with pkgs; [
      material-design-icons
      inter
      material-symbols
      rubik
      ibm-plex
      nerdfonts
      hack-font
      # (nerdfonts.override {fonts = ["Iosevka" "CascadiaCode" "JetBrainsMono"];})
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
      # one of these was causing multiple wayland applications to crash (mostly firefox)
      # GBM_BACKEND = "nvidia-drm";
      # __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      # WLR_RENDERER = "vulkan";
      GBM_BACKEND = "nvidia-drm"; # required to run the correct GBM backend for nvidia GPUs on wayland
      CLUTTER_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland... why do i use electron?
      XCURSOR_THEME = "graphite-dark";
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
      ###############
      # KISS PLEASE #
      ###############
      graphite-cursors # cursor package, is this handled by /home/gtk/default.nix now? nope manual atm
      gnome-text-editor # still might want something with slightly more features, bit too barebones?
      nix-init # git flake helper
      remmina # rdp client
      fet-sh # minimalistic fetch script
      brightnessctl # brightness control, used in waybar TODO laptop / notebook specific not needed as no worky on desktop :)
      cinnamon.nemo-with-extensions # file manager
      qview # image viewer
      gnome.seahorse # key management
      gscreenshot # image capture
      hyprpicker # colour picker for wayland TODO fix script
      imagemagick # bitmap editor cli
      # slack # work # nope electron byeee
      libnotify # notifications
      # gimp-with-plugins # gimp, handy to have, failed to build with 11/03/24 flake update
      wf-recorder # screen recorder
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      bitwarden # password manager
      # armcord # discord wrapper / chat # nope electron
      sleek-grub-theme # testing grub themes TODO grub
      adi1090x-plymouth-themes # plymouth themes
      ntfs3g # ntfs support

      ## TESTING ##
      tmux
      tmuxifier
      # libfprint-2-tod1-goodix
      inputs.wallpaper-generator.defaultPackage.x86_64-linux
      ## TESTING ##

      # (callPackage ../packages/image-colorizer {})
      # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
      # (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
      # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
    ];
  };
}
