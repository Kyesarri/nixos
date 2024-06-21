{
  config,
  pkgs,
  inputs,
  spaghetti,
  ...
}: {
  # low memory / resource usage config, runs around 500mb ram used idle at desktop
  imports = [./console.nix];
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.config.allowUnfree = true;

  security.pam.services = {
    gdm.enableGnomeKeyring = true; # keyring support for GDM
    swaylock = {}; # enables pam for swaylock, otherwise cannot unlock system
  };

  nix = {
    package = pkgs.nixVersions.latest;
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
    pulseaudio.enable = false;
    opengl = {
      enable = true;
      driSupport = true;
    };
  };

  services = {
    gvfs.enable = true; # trash / other ting support
    gnome.gnome-keyring.enable = true;
    printing.enable = false; # cpus printing, not required
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
    kernelPackages = pkgs.linuxPackages_xanmod; # not using latest branch on this low-powered boi
    kernelParams = [];
    loader = {
      efi.efiSysMountPoint = "/boot";
      grub = {
        enable = true; # want to remove - go back to systemd
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
    packages = [pkgs.hack-font];
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
  };
  programs = {
    dconf.enable = true;
    fish.enable = true; # fishy shell
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
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
      gitAndTools.gitFull
      lxqt.lxqt-policykit
    ];
  };

  users.users.${spaghetti.user} = {
    isNormalUser = true;
    description = "${spaghetti.user}";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      brightnessctl # brightness control, used in waybar config for laptops only
      cinnamon.nemo-with-extensions # file manager
      graphite-cursors # cursor package, is this handled by /home/gtk/default.nix now? nope manual atm

      qview # image viewer
      gnome.seahorse # key management
      shotman # image capture
      hyprpicker # colour picker for wayland
      libnotify # notifications
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      inputs.wallpaper-generator.defaultPackage.x86_64-linux
    ];
  };
}
