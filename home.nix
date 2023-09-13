# ./home.nix
let

  # define colours to be used through home packages
  # should i split these packages out and define colours
  # as global variables ( if that is something which is possible?)

  back = "1F2127";
  alte = "26292E";
  fore = "FFFFFF";

  # usage :
  # example = "#${back}";
  # # is required, workaround to add transparency
  # to enable transparency:
  # example = "#99${back}";
  # uses hex values 00 to ff case is irrelevant

in
{
  home-manager.useUserPackages = true;   # install packages to /etc/profiles instead of ~/.nix-profile
  home-manager.useGlobalPkgs = true;   # this saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.users.kel =
  { pkgs, ... }:
  {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      polybar
      kitty
    ];

    programs.home-manager.enable = true;

    programs.kitty = {
      enable = true;
      settings = {
        active_tab_foreground = "#${fore}";
        active_tab_background = "#${back}";
        foreground = "#${fore}";
        background = "#${back}";
        background_opacity = "0.60"; # matching #99 ~ 60% alpha might change later
        background_blur = "1";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        font_family = "JetBrainsMonoNL NF Regular";
        bold_font = "JetBrainsMonoNL NF ExtraBold";
        italic_font = "JetBrainsMonoNL NF Italic";
        bold_italic_font = "JetBrainsMonoNL NF ExtraBold Italic";
        font_size = "10.0";
        };
    };

    services.polybar = {
      enable = true;
      script = ''polybar main'';
      config = {

## bars
        "bar/main" = {
          width = "100%";
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=regular;";
          height = "3%";
          radius = 0;
          modules-center = "date";
          modules-right = "backlight battery";
          modules-left = "focus";
          module-margin-left = 1;
          module-margin-right = 1;
          background = "#99${back}"; # approx 60%
          foreground = "#${fore}"; # is this the font colour?
          pseudo-transparency = true;
          tray-detached = false;
        };

        "bar/lower" = {
          width = "100%";
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=regular;";
          height = "3%";
          modules-center = "polywins";
          modules-right = "network";
          modules-left = "menu-apps";
          line-size = "2";
          background = "#99${back}"; # approx 60%
          foreground = "#${fore}"; # is this the font colour?
          bottom = "true";
          tray-position = "right";
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
          label-full = "  "; # added space after icon as it was leading off-screen
          type = "internal/battery";
          full-at = 80; # maximum charge for my system, set to 101 to always show charging animation
          battery = "BAT0";
          adapter = "AC";
          poll-interval = 5;

          format-charging = "<animation-charging> <label-charging>";
          format-charging-padding = 1;
          label-charging = "%percentage%% ⚡";
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
          card = "amdgpu_bl0"; # use ls -1 /sys/class/backlight/ to list available cards
          format = "<bar>";
          use-actual-brightness = false; # actual brightness was jumpy, disabled
          enable-scroll = false; # can define scroll behaviour, not working under kde
          bar-width = "10";
          bar-indicator = " ";
          bar-fill = "─";
          bar-empty = "─";
        };

        "module/focus" = {
          type = "internal/xwindow";
          format = "<label>";
          label = " %title%"; # had to add a space to the start of this label, was landing too close to the left edge of the screen
          label-maxlen = 70;
        };

        "module/xkeyboard" = { # move to lower bar once its configured
          type = "internal/xkeyboard";
          format = "<indicator-icon> <label-indicator>"; # not working, need to run through this once again
          label-layout = "%icon%";
          indicator-icon-default = "";
          indicator-icon-0 = "🔒;-CL;+CL";
        };

        "module/pulseaudio" = {
          type = "internal/pulseaudio";
          format-volume = "<ramp-volume> <label-volume>";
          label-volume = "%percentage%%";
          label-muted = " ﱝ muted";
          label-muted-foreground = "#666";
          ramp-volume-0 = "";
          ramp-volume-1 = "󰖀";
          ramp-volume-2 = "󰕾";
        };

        # src : https://github.com/uniquepointer/polywins
        "module/polywins" = {
          type = "custom/script";
          exec = "$HOME/nixos/scripts/polywins/polywins.sh";
          format-prefix-foreground = "#${fore}";
          format = "<label>";
          label = "%output%";
          label-padding = "1";
          tail = "true";
        };

        "module/network" = {
          type = "internal/network";
          interface = "wlp2s0";
          interval = "15.0";
          format-connected = "<ramp-signal>";
          format-disconnected = "<label-disconnected>";
          label-disconnected = "󰤭" ;
          format-connected-foreground = "#${fore}";
          format-disconnected-foreground = "#${alte}";
          label-disconnected-foreground = "#${back}";
          format-connected-padding = 3;
          format-disconnected-padding = 3;
          label-disconnected-padding = 3;

          format-connected-background = "";
          format-disconnected-background = "";
          label-disconnected-background = "";

          ramp-signal-0 = "󰤟 ";
          ramp-signal-1 = "󰤢 ";
          ramp-signal-2 = "󰤥 ";
          ramp-signal-3 = "󰤨 ";
        };

        "module/menu-apps" = { # icons were rendering horribly, using text for now - fits better with theme this method
          type = "custom/menu";
          expand-right = true;
          menu-0-0 = "power";
          menu-0-0-exec = "#menu-apps.open.1";
          menu-0-1 = "reboot";
          menu-0-1-exec = "#menu-apps.open.2";
          menu-0-2 = "suspend";
          menu-0-2-exec = "#menu-apps.open.3";

          menu-1-0 = "power";
          menu-1-0-exec = "systemctl poweroff";

          menu-2-0 = "reboot";
          menu-2-0-exec = "systemctl reboot";

          menu-3-0 = "suspend";
          menu-3-0-exec = "systemctl suspend";


          label-open = " 0 ";
          label-close = " x ";

          label-separator = "   ";

        };
      };
    };
  };
}
# ./home.nix
