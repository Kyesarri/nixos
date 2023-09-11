# ./hosts/shared.nix
{ config, pkgs,lib,  ... }:

let
  back = "#1F2127"; # background
  alte = "#26292E"; # alternate
  fore = "#FFFFFF"; # foreground
in
{
  # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
  # using multiple profiles for one user
  home-manager.useUserPackages = true;

  home-manager.users.kel = { pkgs, ... }:
  {

    home.packages = with pkgs; [
      polybar
      kitty
    ];
    home.stateVersion = "23.05";

    programs.kitty = {
      enable = true;
      settings = {
        active_tab_foreground = "${fore}";
        active_tab_background = "${back}";
        foreground = "${fore}";
        background = "${back}";
        # background_opacity = "0.85";
        # background_blur = "1";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        font_family = "JetBrainsMonoNerdFont-Regular";
        bold_font = "JetBrainsMonoNerdFont-ExtraBold";
        italic_font = "JetBrainsMonoNerdFont-Italic";
        bold_italic_font = "JetBrainsMonoNerdFont-BoldItalic";

        };
    };

    services.polybar = {
      enable = true;
      script = ''polybar main'';
      config = {

## bars
        "bar/main" = {
          width = "100%";
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=bold;";
          height = "3.5%";
          radius = 0;
          modules-center = "date xkeyboard";
          modules-right = "backlight battery";
          modules-left = "focus";
          module-margin-left = 1;
          module-margin-right = 1;
          background = "${back}"; # using the colours defined at the top of this .nix
          foreground = "${fore}"; # to keep theming simple and consistant
          tray-position = "right";
          pseudo-transparency = false;
          tray-detached = false;
        };

        "bar/lower" = {

        };

## modules
        "module/date" = {
          type = "internal/date";
          internal = 5;
          date = "%d.%m.%y";
          time = "%H:%M";
          label = "%time% | %date%";
        };

        "module/battery" = {
          label-full = " ";
          type = "internal/battery";
          full-at = 99;
          battery = "BAT0";
          adapter = "AC";
          poll-interval = 5;

          format-charging = "<animation-charging> <label-charging>";
          format-charging-padding = 1;
          label-charging = "%percentage%%";
          animation-charging-0 = " ";
          animation-charging-1 = " ";
          animation-charging-2 = " ";
          animation-charging-3 = " ";
          animation-charging-4 = " ";
          animation-charging-framerate = 500;

          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-padding = 1;
          label-discharging = "%percentage%%";
          ramp-capacity-0 = " ";
          ramp-capacity-1 = " ";
          ramp-capacity-2 = " ";
          ramp-capacity-3 = " ";
          ramp-capacity-4 = " ";
        };

        "module/backlight" = {
          type = "internal/backlight";
          card = "amdgpu_bl0";
          use-actual-brightness = false;
          enable-scroll = false;
        };

        "module/focus" = {
          type = "internal/xwindow";
          format = "<label>";
          label = " %title%"; # had to add a space to the start of this label, was landing too close to the left edge of the screen
          label-maxlen = 70;
        };

        "module/xkeyboard" = {
          type = "internal/xkeyboard";
          format = "<label-indicator>";
          indicator-icon-default = "";
          indicator-icon-0 = "🔒;-CL;+CL";
          indicator-icon-1 = "num lock;-NL;+NL";

        };
        "module/pulseaudio" = { # no builtin support for pulseaudio not enabled for now
          type = "internal/pulseaudio";
          format-volume = "<ramp-volume> <label-volume>";
          label-volume = "%percentage%%";
          label-muted = " ﱝ muted";
          label-muted-foreground = "#666";
          ramp-volume-0 = "";
          ramp-volume-1 = "󰖀";
          ramp-volume-2 = "󰕾";
        };

      };
    };
  };



  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes some connection issues with tailscale, could not find local network without this option
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPorts = [ 41641 ]; # tailscale
      allowedTCPPorts = [ 3389 ]; # rdp
    }; # firewall
  }; # networking

  services = {
    tailscale = {
      useRoutingFeatures = "client";
    };
  };

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false; # workaround for a bug with networking when building with flakes
      systemd-networkd-wait-online.enable = false; # unsure if this affects desktop but leaving here
    }; # services
  }; # systemd

  programs = {
    partition-manager.enable = true;
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "libsecret";
    };
    dconf.enable = true;
    zsh  = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "fino-time";
        plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
          "colorize"
        ]; # plugins
      }; # ohMyZsh
      syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "line" ];
      syntaxHighlighting.patterns = { };
      syntaxHighlighting.styles = { "globbing" = "none"; };
      promptInit = "info='n os wm sh n' fet.sh";
    }; # zsh
  }; # programs

  environment = {
    sessionVariables = { GTK_THEME = "Qogir-Dark"; };
    shells = with pkgs; [ zsh ];
    systemPackages = with pkgs; [
    tailscale
    i2c-tools
    _2bwm
    ]; # systemPackages
  }; # environment

 users = {
    defaultUserShell = pkgs.zsh;
    users.kel = {
      isNormalUser = true;
      description = "kel";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        firefox
        kate
        kdeconnect
        nvtop
        tailscale
        tailscale-systray
        qogir-theme
        qogir-kde
        qogir-icon-theme
        xsel
        nil
        kdevelop
        remmina
        fet-sh
        isoimagewriter
        libsForQt5.lightly
        ]; # packages
    }; # users.kel
  }; # users

}
# ./hosts/shared.nix
