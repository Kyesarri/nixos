{
  pkgs,
  inputs,
  config,
  spaghetti,
  ...
}: {
  system.stateVersion = "23.11"; # don't change this value pls
  time.timeZone = "Australia/Melbourne";
  nixpkgs.config.allowUnfree = true;

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  nix = {
    #
    sshServe.enable = true;
    package = pkgs.nixVersions.latest; # "unstable"
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    settings = {
      auto-optimise-store = true; # runs gc, need to set interval otherwise defaults to 14d from memory
      experimental-features = ["nix-command" "flakes"]; # flakes and nixcommand required for config
      substituters = [
        "https://hyprland.cachix.org" # hyprland cache, prevents building from source tyty
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };

  # language
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

  # eeeeh don't like this being here #TODO
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [3389]; # rdp
  };

  services = {
    xserver.enable = false;
    openssh.enable = true;
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gvfs.enable = true; # trash and mount
    tumbler.enable = true; # thumbnail support
    printing.enable = true; # need more than this to print afik? http://localhost:631/ for config
  };

  fonts = {
    fontconfig.defaultFonts.monospace = ["Hack Nerd Font Mono"];
    fontDir.enable = true;
    packages = with pkgs; [
      material-design-icons
      inter
      material-symbols
      ibm-plex
      hack-font
    ];
  };

  programs = {
    corectrl.enable = true;
    dconf.enable = true;
    seahorse.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = ["graphical-session.target"];
      wants = ["graphical-session.target"];
      after = ["graphical-session.target"];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  environment = {
    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
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
      XCURSOR_THEME = "graphite-dark"; # is a user package below
    };

    shells = [pkgs.zsh]; # default shell to zsh

    # system packages, available for all users, not just spaghetti (su)
    systemPackages = with pkgs; [
      pciutils
      tailscale
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
      gitAndTools.gitFull
      polkit_gnome
      waypipe
      keepassxc # password manager
      home-manager
      inkscape-with-extensions
      netbird
      netbird-ui
    ];
  };

  users.users.${spaghetti.user} = {
    shell = pkgs.zsh;
    isNormalUser = true;
    description = "${spaghetti.user}";
    extraGroups = [
      "networkmanager" # network
      "wheel" # sudo
      "plugdev" # usb
    ];

    # packages available for just our spaghetti user
    packages = with pkgs; [
      gimp-with-plugins # image boi
      ladybird # testing, alpha 2026 :D
      graphite-cursors # cursor package, is this handled by /home/gtk/default.nix now? nope manual atm
      gnome-text-editor # still might want something with slightly more features, bit too barebones?
      nix-init # git flake helper
      remmina # rdp client
      fet-sh # minimalistic fetch script
      brightnessctl # brightness control, used in waybar TODO laptop / notebook specific not needed as no worky on desktop :)
      qview # image viewer
      imagemagick # bitmap editor cli
      libnotify # notifications
      wf-recorder # screen recorder
      mate.mate-calc # calc
      p7zip # TODO needs a gui
      udiskie # usb mounting
      ntfs3g # ntfs support
      wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
      vlc # play me some vids
      usbimager # says on the tin
      ventoy-full # usb image lad
      evolutionWithPlugins # calendar
      blender # for new toy :D
      gnome-disk-utility # disk gui
      libimobiledevice # fix iphone thing
      usbmuxd2 # another ios thing
      libirecovery # more ios?
      ifuse # more iphone thing
      orca-slicer # still isn't working
      openscad # 3d cad
      nfs-utils # nfs user utilities
      handbrake # convert video files
      inputs.wallpaper-generator.defaultPackage.x86_64-linux
      inputs.quickshell.packages.x86_64-linux.default
    ];
  };
}
