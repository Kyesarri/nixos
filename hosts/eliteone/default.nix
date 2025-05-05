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

    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./containers.nix
    ./per-device.nix
    ../standard.nix

    ../../hardware
    ../../hardware/audio

    ../../home

    ../../home/cosmic
    ../../home/bottom
    ../../home/codium
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/git
    ../../home/keepassxc

    ../../home/gtk
    ../../home/kitty
    ../../home/kde
    ../../home/ulauncher
    ../../home/virt
    ../../home/waybar
    ../../home/wl-screenrec
    ../../home/prism
    ../../home/syncthing
    ../../home/spotifyd
    ../../home/tailscale

    ../../home/tmux
    ../../home/zsh
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  users.users.${spaghetti.user}.uid = 1000;

  gnocchi = {
    hypr = {
      enable = false;
      animations = false;
    };
    hyprpaper.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
  };

  services = {
    openssh.enable = true;
    fstrim.enable = true;
    xserver.enable = true;
    services.displayManager.cosmic-greeter.enable = true; # lol this won't work
    /*
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "weston";
      settings = {
        Wayland = {
          CompositorCommand = "${pkgs.weston}/bin/weston --shell=kiosk -c /home/${spaghetti.user}/nixos/hosts/eliteone/weston.ini";
        };
      };
    };
    */
    desktopManager.plasma6.enable = true;

    # desktop / plasma6 should set this
    # dbus.enable = true;

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
    shells = with pkgs; [zsh];
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-eliteone --show-trace";
    };

    sessionVariables = {
      VDPAU_DRIVER = "va_gl";
      LIBVA_DRIVER_NAME = "iHD";
      GTK_THEME = "${config.colorscheme.slug}";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      SDL_VIDEODRIVER = "wayland";
      QT_QPA_PLATFORM = "wayland";
    };

    systemPackages = with pkgs; [
      ethtool
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
      pciutils
      cockpit
      spotifyd
    ];
  };
}
