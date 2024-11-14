{
  pkgs,
  inputs,
  config,
  spaghetti,
  nix-colors,
  ...
}: let
  cockpit-apps = pkgs.callPackage ../../home/cockpit/default.nix {inherit pkgs;};
in {
  imports = [
    nix-colors.homeManagerModules.default

    ./boot.nix # may migrate systems back to systemd boot - testing here
    ./hardware.nix # device specific hardware config
    ./networking.nix # systemd networking config
    ./containers.nix # testing selecting specific ccontainers per-host

    ../headless.nix # base packages and config

    ../../hardware # new module configs - will replace importing modules
    ../../hardware/ups

    ../../home # home-manaager config for all machines
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/cockpit # testing cockpit-podman web gui
    ../../home/codium # need to add server into this
    ../../home/git # basic git configs
    ../../home/gtk # themes still needed for console
    ../../home/kitty # is this needed on headless? probs not
    ../../home/tmux
    ../../home/zsh # nice to have
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};

  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};

  users.users.${spaghetti.user}.uid = 1000;

  gnocchi = {
    coral.enable = true;
  };

  services = {
    openssh.enable = true;
    xserver.enable = false; # headless
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    printing.enable = false; # cpus printers
    gnome.gnome-keyring.enable = true; # keyboi

    dbus = {
      enable = true;
      packages = [pkgs.seahorse];
    };

    chrony = {
      enable = true;
      enableNTS = true;
    };

    zfs = {
      autoScrub.enable = true;
      trim.enable = true;
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        x11.enable = false;
        wall.enable = true;
      };
    };

    ###### TODO ######
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "server"; # main requirement for the # TODO
    tailscale.openFirewall = true;
    ###### TODO ######
  };

  environment = {
    shells = with pkgs; [zsh]; # default shell to zsh
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-erying --show-trace";
      webcam = "ustreamer --device=/dev/v4l/by-id/usb-Alpha_Imaging_Tech._Corp._Razer_Kiyo-video-index0 --host=0.0.0.0 --port=80 -f 60 -r 1920x1080 -m MJPEG";
    };
    sessionVariables = {
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
      zfs
      cockpit
      cockpit-apps.podman-containers
    ];
  };
}
