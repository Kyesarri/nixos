{
  pkgs,
  inputs,
  config,
  spaghetti,
  ...
}: {
  system.stateVersion = "23.11"; # don't change this value pls

  time.timeZone = "Australia/Melbourne";

  nixpkgs = {
    overlays = [];
    config.allowUnfree = true;
  };

  nix = {
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
    openssh.enable = true;
    fstrim.enable = true; # ssd trim in background, not enabled by default :0
    gvfs.enable = true; # trash and mount
    tumbler.enable = true; # thumbnail support
    printing.enable = true; # need more than this to print afik? http://localhost:631/ for config
    userborn.enable = true;
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
    adb.enable = true;
    corectrl.enable = true;
    dconf.enable = true;
    # uwsm.enable = true; # TODO
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

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "librewolf.desktop";

      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";

      "application/x-extension-htm" = "librewolf.desktop";
      "application/x-extension-shtml" = "librewolf.desktop";
      "application/xhtml+xml" = "librewolf.desktop";
      "application/x-extension-xhtml" = "librewolf.desktop";
      "application/x-extension-xht" = "librewolf.desktop";

      "video/x-matroska" = "vlc.desktop";
      "text/html" = "librewolf.desktop";

      "image/jpeg" = ["qview.desktop"];
      "image/bmp" = ["qview.desktop"];
      "image/png" = ["qview.desktop"];

      # add image types "qView.desktop";
    };
  };

  environment = {
    sessionVariables = {
      CLUTTER_BACKEND = "wayland";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      XDG_SESSION_TYPE = "wayland";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland... why do i use electron? fucking codium
    };

    shells = [pkgs.zsh]; # default shell to zsh

    # system packages, available for all users, not just spaghetti (su)
    systemPackages = with pkgs; [
      cifs-utils
      samba
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
      lm_sensors
      inputs.agenix.packages.x86_64-linux.default
    ];
  };

  users = {
    groups.media = {
      name = "media";
      gid = 989;
      members = ["${spaghetti.user}"];
    };
    users.${spaghetti.user} = {
      shell = pkgs.zsh;
      isNormalUser = true;
      description = "${spaghetti.user}";
      extraGroups = [
        "networkmanager" # network
        "wheel" # sudo
        "plugdev" # usb
        "audio"
        "video"
        "pipewire"
        "adbusers" # android
      ];

      # packages available for just our spaghetti user
      packages = with pkgs; [
        gimp-with-plugins # image boi
        ladybird # testing, alpha 2026 :D
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
        evolutionWithPlugins # calendar
        blender # for new toy :D
        gnome-disk-utility # disk gui
        nfs-utils # nfs user utilities
        handbrake # convert video files
        compose2nix # convert dockercompose.yml to .nix
        inputs.wallpaper-generator.defaultPackage.x86_64-linux
        koodo-reader # ebook reader
        godot
        scrcpy
        # grayjay
      ];
    };
  };
}
