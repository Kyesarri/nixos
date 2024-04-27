{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  spaghetti,
  sops-nix,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./boot.nix
    ./hardware.nix # device specific hardware config
    ./networking.nix # systemd networking config

    ../headless.nix # base packages and config, may need to move some of those values to this config

    ../../containers

    ../../home # home-manaager config for all machines currently
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/git # some baseline git config in there
    ../../home/kitty # yes pls
    ../../home/codium # need to add server into this
    ../../home/virt # ehhhhh not sure if wanted / needed whatsoever
    ../../home/gtk # has some theming bits, might have some requirement still
    ../../home/zsh # yes pls

    ../../serv # import all serv...ices
  ];

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/${spaghetti.user}/.config/sops/age/keys.txt";
    secrets = {
      "network/gateway" = {};
    };
  };

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

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

    # used for cameras ntp - can i make this host, use this ntp server? :D
    # sounds like it'l cause issues, lets send

    chrony = {
      enable = true;
      enableNTS = true;
      servers = [
        "ntp.nml.csiro.au"
        "ntp.ise.canberra.edu.au"
      ];
    };

    smartd = {
      enable = true;
      autodetect = true;
      notifications = {
        x11.enable = false;
        wall.enable = true;
      };
    };
  };

  hardware = {
    pulseaudio.enable = false;
    enableRedistributableFirmware = lib.mkDefault true;
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
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-serv --show-trace";
    sessionVariables = rec
    {
      LIBVA_DRIVER_NAME = "iHD"; # Force intel-media-driver
      GTK_THEME = "${config.colorscheme.slug}"; # sets default gtk theme the package built by nix-colors
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
    };

    shells = with pkgs; [zsh]; # default shell to zsh
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
      zfs
    ];
  };
}
