{
  pkgs,
  inputs,
  config,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./boot.nix # may migrate systems back to systemd boot - testing here
    ./hardware.nix # device specific hardware config
    ./networking.nix # systemd networking config
    ./containers.nix # testing selecting specific containers per-host
    ./per-device.nix # monitor config more to come

    ../standard.nix # base packages and config

    ../../hardware # new module configs - will replace importing modules

    ../../home # home-manaager config for all machines
    ../../home/cosmic # testing cosmic package - really fast!
    ../../home/bottom # task-manager
    ../../home/codium # #TODO pin versions to avoid compiling
    ../../home/copyq # #TODO change to an alternative maybe?
    ../../home/dunst # notifications
    ../../home/firefox # why you always need to build from source, check to see if there are nighty / beta precompiled
    ../../home/git # add some basic git packages
    ../../home/keepassxc # key / password manager

    ../../home/gtk # themes still needed for console
    ../../home/kitty # is this needed on headless? probs not
    ../../home/kde # TODO rename kdeconnect - maybe not lol - covers lots
    ../../home/ulauncher # TODO rename built theme, add credits to og author
    ../../home/virt # vm / container
    ../../home/waybar # wayland bar boi, needs another go at theming
    ../../home/wl-screenrec # testing for laptop - amd / nvidia config
    ../../home/prism # wallpapers
    ../../home/syncthing # sync the things
    ../../home/tailscale # not foss, temp - will replace eventually with netbird / self-hosted

    ../../home/tmux
    ../../home/zsh # nice to have
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};

  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};

  users.users.${spaghetti.user}.uid = 1000;

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
    hyprpaper.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
    wifi.backend = "nwm";
  };

  services = {
    openssh.enable = true;
    xserver.enable = false; # headless
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gnome.gnome-keyring.enable = true; # keyboi

    dbus = {
      enable = true;
      packages = [pkgs.seahorse];
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        x11.enable = false;
        wall.enable = false;
      };
    };
  };

  environment = {
    shells = with pkgs; [zsh]; # default shell to zsh
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-eliteone --show-trace";
    };
    sessionVariables = {
      VDPAU_DRIVER = "va_gl";
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    systemPackages = with pkgs; [
      ethtool
      nut # ups monitor
      lm_sensors # sensor monitoring
      lshw # list hardware
      tailscale # lets users control tailscale
      usbutils
      busybox
      libva-utils
      curl
      wget
      libsecret
      gitAndTools.gitFull
      polkit_gnome
      pciutils
      cockpit
    ];
  };
}
