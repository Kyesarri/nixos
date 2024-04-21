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
    ./per-device.nix # per device hypr config # not required, TODO remove?

    ./hardware.nix # device specific hardware config
    ../../hardware/audio # probs worthwile for warning sounds or something

    ../headless.nix # base packages and config, may need to move some of those values to this config

    ../../containers # handles networking / bridge for host / containers
    ../../containers/plex # oci / podman not nix-container
    ../../containers/home-assistant # not much managed within nix yet
    ../../containers/frigate # testing in podman, working OK! 9900k iGPU is trash compared to old nix-serv RIP # TODO increase iGPU Vram
    # ../../containers/emqx # emqx not working currently
    ../../containers/codeproject # was using this for frigate detections

    ../../containers/blocky # testing, to replace pi-hole lxc on proxmox
    # ../../containers/authelia # local web auth

    ../../home # home-manaager config for all machines currently
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/git # some baseline git config in there
    ../../home/kitty # yes pls
    ../../home/codium # need to add server into this
    ../../home/virt # ehhhhh not sure if wanted / needed whatsoever
    ../../home/gtk # has some theming bits, might have some requirement still
    ../../home/zsh # yes pls

    ../../serv/arr
    ../../serv/nginx # reverse proxy boi
    ../../serv/caddy

    # ../../serv/changedetection

    # ../../home/syncthing # testing without currently
    # ../../home/tailscale # TODO disabled until i can figure out mkif hostname == {nix-serv}; with an else
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  users.users.${spaghetti.user}.uid = 1000;

  networking = {
    hostName = "nix-serv";
    hostId = "bed5b7cd";
    # moved most conf to /containers/default.nix due to bridge conf
    firewall = {
      enable = true;
      allowedTCPPorts = [
        22 # ssh, possibly open already but leaving in
        123 # chrony ntp, not working?
      ];
      checkReversePath = "loose"; # fixes some connection issues with tailscale
      allowedUDPPorts = [
        41641 # tailscale TODO not needed with openFirewall?
        123 # chrony ntp
      ];
    };
  };

  # tailscale config above is temp, will remove once below # TODO has been completed

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
      # notifies via cli on failing disks
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
      linuxKernel.packages.linux_xanmod.gasket # coral tpu
      lshw
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
