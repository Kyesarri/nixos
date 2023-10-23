# ./hosts/shared.nix
# all the home-manager items can be moved to another nix "soon"
{
  config,
  pkgs,
  lib,
  outputs,
  inputs,
  ...
}: {
  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes some connection issues with tailscale, could not connect to tailnet or internet outside of home -
      # without this option enabled
      allowedTCPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # kdeconnect
      allowedUDPPortRanges = [
        {
          from = 1714;
          to = 1764;
        }
      ]; # kdeconnect
      allowedUDPPorts = [41641]; # tailscale
      allowedTCPPorts = [3389]; # rdp
    };
  };

  services.tailscale.useRoutingFeatures = "client"; # set as client for tailscale
  services.upower = {
    enable = true; # using upower for battery monitoring, waybar needs some configuration for this too :)
    percentageCritical = 10;
    percentageLow = 15;
  };

  programs = {
    dconf.enable = true;
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.highlighters = ["main" "brackets" "pattern" "cursor" "line"];
      syntaxHighlighting.patterns = {};
      syntaxHighlighting.styles = {"globbing" = "none";};
      promptInit = "info='n host cpu os wm sh n' fet.sh";
      ohMyZsh = {
        enable = true;
        theme = "fino-time";
        plugins = ["sudo" "terraform" "systemadmin" "vi-mode" "colorize"];
      };
    };
  };

  environment = {
    sessionVariables = rec
    {
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "gtk2";
      MOZ_ENABLE_WAYLAND = "1";
      GTK_THEME = "Tokyonight-Dark-B"; # sets default gtk theme to dark
      #      GTK_ICON_THEME = "Qogir-Dark"; # dont know if this works, does not throw an error but no icons are appplied :)
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config"; # moves config to home/share rather than home/.config
      XDG_DATA_HOME = "$HOME/dots/share"; # will move to /home/nixos soon
      XDG_STATE_HOME = "$HOME/dots/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland
    };
    shells = with pkgs; [zsh]; # default shell to zsh
    systemPackages = with pkgs; [
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
      gitAndTools.gitFull
      lxqt.lxqt-policykit
    ];
  };

  users = {
    defaultUserShell = pkgs.zsh;
    users.kel = {
      isNormalUser = true;
      description = "kel";
      extraGroups = ["networkmanager" "wheel"];
      packages = with pkgs; [
        firefox # the lad
        nvtop # watching gpu usage
        tailscale # mah boi
        tailscale-systray
        qogir-theme # used to set dark theme for gtk applications
        remmina # rdp client
        fet-sh # minimalistic fetch script
        hyprpaper # wallpaper for wayland
        gnome-builder # ide / basic boi
        pamixer # cli pulse audio mixer
        pavucontrol # audio control gui
        brightnessctl # brightness control, used in waybar config
        qogir-icon-theme # icons, not sure how to use :)
        qogir-theme # theme
        wl-color-picker # wayland colour picker
        cinnamon.nemo-with-extensions # file manager
        qview # image viewer
        bottom # hot CLI task manager
        gnome.seahorse # key management
        blueberry # bluetooth gui
        shotman # screenshot gui
        hyprpicker # colour picker for wayland
        copyq # wayland clipboard manager
        tokyo-night-gtk # gtk theme
        swaylock-effects # lockscreen of sorts
        iwd # wireless network daemon
        iwgtk # replaces network-manager-applet
        # eww-wayland # do want to see if this is easier to config than WCP, loads faster?
        slack
        wpgtk
        pywal
        python3
        libnotify
        wlogout
        go-upower-notify
        mate.engrampa # archive manager from mate
        (callPackage ../packages/tokyonight-kde {})
        # (callPackage ../packages/wcp {}) # IT WORKS! Currently has bugs with RGBA colours, see package notes
        (callPackage ../packages/libfprint {}) # builds, need to write to the fprint reader now :)
        # (callPackage ../packages/sov {}) # sway overview, needs some hyprland config to see if works on hyprland
      ];
    };
  };
}
# ./hosts/shared.nix

