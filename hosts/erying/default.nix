{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  spaghetti,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./boot.nix # may migrate systems back to systemd boot - testing here
    ./hardware.nix # device specific hardware config
    # ./networking.nix # systemd networking config
    ./net-test.nix # testing ground for networking
    ./containers.nix # testing selecting specific ccontainers per-host

    ../headless.nix # base packages and config

    ../../home # home-manaager config for all machines
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/git # some baseline git config in there
    ../../home/kitty # yes pls
    ../../home/codium # need to add server into this
    ../../home/gtk # has some theming bits, might have some requirement still
    ../../home/zsh # yes pls
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${spaghetti.user}/.config/sops/age/keys.txt";
    secrets = {
      #"network/gateway" = {};
    };
  };
  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme2};

  users.users.${spaghetti.user}.uid = 1000;

  services = {
    openssh.enable = true;
    xserver.enable = false; # headless
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gvfs.enable = true; # gnome trash support
    printing.enable = false; # cpus printers
    gnome.gnome-keyring.enable = true; # keyboi

    dbus = {
      enable = true;
      packages = [pkgs.gnome.seahorse];
    };

    ###### TODO ######
    tailscale.enable = true;
    tailscale.useRoutingFeatures = "server"; # main requirement for the # TODO
    tailscale.openFirewall = true;
    ###### TODO ######
  };

  hardware = {
    pulseaudio.enable = false;
    # enableRedistributableFirmware = lib.mkDefault true;
    opengl = {
      enable = true;
      driSupport = true;
      extraPackages = with pkgs; [
        vaapiIntel
        libvdpau-va-gl
        vaapiVdpau
        intel-ocl
        intel-media-driver # LIBVA_DRIVER_NAME=iHD
        intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      ];
    };
  };

  environment = {
    shells = with pkgs; [zsh]; # default shell to zsh
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-erying --show-trace";
    sessionVariables = rec
    {
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    systemPackages = with pkgs; [
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
      age
    ];
  };
}
