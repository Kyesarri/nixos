{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  spaghetti,
  ...
}: {
  imports = [./console.nix];
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;

  # security.pam.services = {gdm.enableGnomeKeyring = true;};

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
    openssh.enable = true;
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gvfs.enable = true; # gnome trash support
    printing.enable = true; # need more than this to print afik? http://localhost:631/ for config
    dbus = {
      enable = true;
      packages = [pkgs.keepassxc];
    };
    # gnome.gnome-keyring.enable = true;
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
    seahorse.enable = true;
  };

  environment = {
    sessionVariables = rec
    {
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
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland... why do i use electron? fucking codium
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
      age # is secret
      keepassxc # another key manager - replace bitwarden and sops-nix?
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
      termius
      graphite-cursors # cursor package, is this handled by /home/gtk/default.nix now? nope manual atm
      gnome-text-editor # still might want something with slightly more features, bit too barebones?
      nix-init # git flake helper
      remmina # rdp client
      fet-sh # minimalistic fetch script
      brightnessctl # brightness control, used in waybar TODO laptop / notebook specific not needed as no worky on desktop :)
      cinnamon.nemo-with-extensions # file manager
      qview # image viewer
      gscreenshot # image capture
      hyprpicker # colour picker for wayland TODO fix script
      imagemagick # bitmap editor cli
      libnotify # notifications
      # gimp-with-plugins # gimp, handy to have, failed to build with 11/03/24 flake update
      wf-recorder # screen recorder
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      bitwarden # password manager
      sleek-grub-theme # testing grub themes TODO grub
      ntfs3g # ntfs support
      curl
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout

      ## TESTING ##
      xpipe
      tmux
      tmuxifier
      inputs.wallpaper-generator.defaultPackage.x86_64-linux
      ## TESTING ##

      # (callPackage ../packages/image-colorizer {})
      # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
      # (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
      # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
    ];
  };
}
