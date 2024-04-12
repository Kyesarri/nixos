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

    ../headless.nix # base packages and config, may need to move some of those values to this config

    ../../containers # handles networking / bridge for host / containers
    ../../containers/nginx # reverse proxy boi
    ../../containers/blocky # testing, to replace pi-hole lxc on proxmox
    ../../containers/authelia # local web auth

    ../../hardware/audio # probs worthwile for warning sounds or something
    ../../hardware/battery # this server comes with its own built-in "ups"

    ../../home # home-manaager config for all machines currently
    ../../home/bottom # nice to have terminal task manager / perfmon
    ../../home/frigate # testing in docker, not on metal TODO - docker :D
    ../../home/git # some baseline git config in there
    ../../home/kitty # yes pls
    ../../home/codium # need to add server into this
    ../../home/virt
    ../../home/gtk # has some theming bits, might have some requirement still
    ../../home/zsh # yes pls

    # ../../home/syncthing # testing without currently
    # ../../home/tailscale # TODO disabled until i can figure out mkif hostname == {nix-serv}; with an else
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};
  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme1};

  users.users.${spaghetti.user}.uid = 1000;

  networking = {
    hostName = "nix-serv";
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
    printing.enable = false; # cpus printer thingy
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

    # used for cameras ntp
    chrony = {
      enable = true;
      enableNTS = true;
      servers = [
        "ntp.nml.csiro.au"
        "ntp.ise.canberra.edu.au"
      ];
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        # optional helps save long term battery health
        ## using battery as ups for this machine :)
        START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 65; # 65 and above it stops charging
        # unsure if these are actually applying on this system yet, do not believe so
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
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
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
