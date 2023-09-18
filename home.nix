# ./home.nix
let

  # define colours to be used through home packages

  colour = import ./modules/colour.nix;

  # usage:
  # example = "#${colour.red1}";
  # # is required, workaround to add transparency if required later
  # to enable transparency:
  # example = "#99${colour.back}";
  # uses hex values 00 to ff case is irrelevant

  # TODO: change the strings from "red1" and so forth to something less descriptive of the colour but the region its used in. EX: red1 to accent1
  # TODO: this will make fleshing out new themes easier for my system

in
{
  home-manager.useUserPackages = false;   # install packages to /etc/profiles instead of ~/.nix-profile
  home-manager.useGlobalPkgs = true;   # this saves an extra Nixpkgs evaluation, adds consistency, and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.users.kel =
  { pkgs, config, ... }:
  {
    home.username = "kel";
    programs.home-manager.enable = true;

    home.stateVersion = "23.05";
    home.packages = with pkgs; [
      polybar
      kitty
      eww
      rofi # might be used with 2bwm at a later time, for now disabled
    ];

    programs.kitty =
    {
      enable = true;
      settings =
        {
        active_tab_foreground = "#${colour.red1}";
        active_tab_background = "#${colour.back}";
        foreground = "#${colour.text}";
        background = "#${colour.back}";
        background_opacity = "1.0";
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

    services.polybar =
    {
      enable = true;
      script = ''polybar top'';
      config =
        {
        "bar/top" =
        {
          wm-name = "top";
          width = "100%";
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=regular;";
          height = "25";
          radius = 0;
          modules-center = "date";
          modules-right = "backlight network battery arrow";
          modules-left = "focus";
          module-margin-left = 1;
          module-margin-right = 1;
          background = "#${colour.back}";
          foreground = "#${colour.text}";
          pseudo-transparency = true;
          tray-detached = false;
          line-size = 1;
          border-top-size = 0;
          border-bottom-size = 0;
        };

        "bar/bot" =
        {
          wm-name = "bot";
          width = "100%";
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=regular;";
          font-1 = "JetBrainsMonoNerdFont:size=20:weight=regular;";
          height = "25";
          modules-center = "polywins";
          radius = 0;
          modules-right = "";
          modules-left = "menu-apps";
          module-margin-left = 1;
          module-margin-right = 1;
          line-size = "1";
          background = "#${colour.back}";
          foreground = "#${colour.text}";
          bottom = "true";
          pseudo-transparency = true;
          border-top-size = 0;
          border-bottom-size = 0;
        };

        "bar/tasktray" =
        {
          wm-name = "tasktray";
          monitor-strict = false;
          font-0 = "JetBrainsMonoNerdFont:size=10:weight=regular;";
          width = "20";
          height = "25";
          offset-x = "98%"; ######### offset values only dtermine the position of bar in the screen set it accordingly to your need
          offset-y = "35";
          override-redirect = "true"; ############### to make offset vales to work override-direct value must be true
          fixed-center = true;
          background = "#${colour.back}";
          foreground = "#${colour.alte}";
          radius = "10";
          line-size = "0";
          #line-colour = #f00
          padding-left = "0";
          padding-right = "1";
          module-margin-left = "0";
          module-margin-right = "0";
          modules-right = "arrow";
          tray-position = "right";
          tray-detached = "false";
          tray-offset-x = "0";
          tray-offset-y = "0";
          tray-padding = "1";
          tray-maxsize = "20";
          tray-scale = "1";
          tray-background = "#${colour.back}";
          tray-foreground = "#${colour.alte}";
        };

## modules

        "module/date" =
        {
          type = "internal/date";
          internal = 5;
          date = "%d.%m.%y";
          time = "%H:%M";
          label = "%time% | %date%"; # do some on-click here for " plasmawindowed org.kde.plasma.calendar" to show the calendar
        }; # to show all kde plasmoids run " kpackagetool5 --list --type Plasma/Applet -g  # system wide "

        "module/battery" =
        {
          label-full = "  "; # added space after icon as it was leading off-screen
          type = "internal/battery";
          full-at = 80; # maximum charge for my system, set to 101 to always show charging animation
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

          ramp-capacity-0-foreground = "#${colour.red1}";
          ramp-capacity-1-foreground = "#${colour.red1}";
          ramp-capacity-2-foreground = "#${colour.red1}";
          ramp-capacity-3-foreground = "#${colour.red1}";
          ramp-capacity-4-foreground = "#${colour.red1}";

          format-discharging = "<ramp-capacity> <label-discharging>";
          format-discharging-padding = 1;
          label-discharging = "%percentage%%";
          ramp-capacity-0 = " ";
          ramp-capacity-1 = " ";
          ramp-capacity-2 = " ";
          ramp-capacity-3 = " ";
          ramp-capacity-4 = " ";
        };

        "module/backlight" =
        {
          type = "internal/backlight";
          card = "amdgpu_bl0"; # use ls -1 /sys/class/backlight/ to list available cards
          format = "<bar>";
          use-actual-brightness = false; # actual brightness was jumpy, disabled
          enable-scroll = false; # can define scroll behaviour, not working under kde
          bar-width = "10";
          bar-indicator = "─";
          bar-indicator-foreground = "#${colour.red1}";
          bar-fill = "─";
          bar-empty = "─";
        };

        "module/focus" =
        {
          type = "internal/xwindow";
          format = "<label>";
          label = " %title%"; # had to add a space to the start of this label, was landing too close to the left edge of the screen
          label-maxlen = 70;
        };

        "module/xkeyboard" = # not sure if this should be kept :)
        {
          type = "internal/xkeyboard";
          format = "<indicator-icon> <label-indicator>"; # not working, need to run through this once again
          label-layout = "%icon%";
          indicator-icon-default = "";
          indicator-icon-0 = "🔒;-CL;+CL";
        };

        "module/pulseaudio" =
        { # not using pulseaudio but pipewire, unsure how to continue here
          type = "internal/pulseaudio";
          format-volume = "<ramp-volume> <label-volume>";
          label-volume = "%percentage%%";
          label-muted = " ﱝ muted";
          label-muted-foreground = "#666";
          ramp-volume-0 = "";
          ramp-volume-1 = "󰖀";
          ramp-volume-2 = "󰕾";
        };

        # src : https://github.com/uniquepointer/polywins / https://codeberg.org/kye/polywins --fork
        "module/polywins" =
        {
          type = "custom/script";
          exec = "$HOME/nixos/scripts/polywins/polywins.sh";
          format-prefix-foreground = "#${colour.text}";
          format = "<label>";
          label = "%output%";
          label-padding = "1";
          tail = "true";
        };

        "module/network" =
        {
          format-disconnected-underline = "#${colour.red1}";
          label-foreground = "#${colour.red1}";
          type = "internal/network";
          interface = "wlp2s0";
          interval = "3.0";
          label-connected = "%local_ip%";
          format-disconnected = "disconnected";

        };

        "module/menu-apps" =
        {
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

          label-open = "  ";
          label-close = "  ";
          label-close-foreground = "#${colour.red1}";
          label-separator = " ";
        };

        "module/arrow" =
        {
          type = "custom/script";
          exec = "exec $HOME/nixos/scripts/polybar-tray/arrow.sh";
          click-left = "exec $HOME/nixos/scripts/polybar-tray/open.sh";
          click-right = "pkill -f tasktray";
        };

        "module/subscriber" = # un used yet
        {
          type = "custom/ipc";
          # Define the command to be executed when the hook is triggered
          # Available tokens:
          # %pid% (id of the parent polybar process)
          hook-0 = "date";
          hook-1 = "whoami";
          hook-2 = "polybar top";

          # Hook to execute on launch. The index is 1-based and using
          # the example below (2) `whoami` would be executed on launch.
          # If 0 is specified, no hook is run on launch
          # Default: 0
          initial = "2";
          # Available tags:
          # <output> (default)
          format = "<output>";
          format-foreground = "#f00";
          format-background = "#fff";
          # Mouse actions
          # Available tokens:
          # %pid% (id of the parent polybar process)
          click-left ="";
          click-middle ="";
          click-right ="";
          scroll-up ="";
          scroll-down ="";
          double-click-left ="";
          double-click-right = "";
        };

      };
    };
  };
}
# ./home.nix
