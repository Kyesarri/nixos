/*
TODO cleanup options
cleanup comments / seperators
just overhaul module :)
*/
{
  spaghetti,
  config,
  inputs,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.gnocchi; # shorthand some lines
in {
  #
  options.gnocchi = {
    hypr.enable = mkOption {
      type = types.bool;
      default = false;
    };
    hypr.animations = mkOption {
      type = types.bool;
      default = false;
    };
    hyprpaper.enable = mkOption {
      type = types.bool;
      default = true;
    };
    #
  };

  #
  config = mkMerge [
    (mkIf (cfg.hypr.enable == true) {
      #
      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        config.common.default = ["gtk"];
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          pkgs.xdg-desktop-portal-gtk
        ];
      };
      #
      environment.sessionVariables = {
        QT_QPA_PLATFORMTHEME = "qt5ct";
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_DESKTOP = "Hyprland";
      };
      #
      users.users.${spaghetti.user}.packages = [
        pkgs.xdg-desktop-portal-hyprland
        pkgs.xdg-desktop-portal-gtk

        pkgs.hyprpicker
        pkgs.hypridle
        pkgs.hyprlock
      ];
      #
      home-manager.users.${spaghetti.user} = {
        services.hypridle.enable = true;
        programs.hyprlock.enable = true;
        wayland.windowManager.hyprland = {
          package = inputs.hyprland.packages.${pkgs.system}.hyprland;
          enable = true;
          systemd.enable = true;
          systemd.variables = ["--all"];
          plugins = [
            inputs.hy3.packages.x86_64-linux.hy3
            # inputs.hycov.packages.x86_64-linux.hycov
            /*
               (inputs.Hyprspace.packages.${pkgs.system}.Hyprspace.overrideAttrs {
              dontUseCmakeConfigure = true;
            })
            */
          ];
          extraConfig = ''
            # ^^ autogen by home-manager ^^
            # this is a hacky workaround, but it works and i don't care
            # pulls config from nix install dir, no symlinks, means faster editing without rebuilds / reloading hypr
            source = /home/${spaghetti.user}/nixos/home/hypr/config/main.conf
          '';
        };
        #
        home.file.".config/hypr/colours.conf" = {
          text = ''
            # add nix-colors below, sourced in hyprland.conf
            $c0 = rgba(${config.colorscheme.palette.base00}FF)
            $c1 = rgba(${config.colorscheme.palette.base01}FF)
            $c2 = rgba(${config.colorscheme.palette.base02}FF)
            $c3 = rgba(${config.colorscheme.palette.base03}FF)
            $c4 = rgba(${config.colorscheme.palette.base04}FF)
            $c5 = rgba(${config.colorscheme.palette.base05}FF)
            $c6 = rgba(${config.colorscheme.palette.base06}FF)
            $c7 = rgba(${config.colorscheme.palette.base07}FF)
            $c8 = rgba(${config.colorscheme.palette.base08}FF)
            $c9 = rgba(${config.colorscheme.palette.base09}FF)
            $ca = rgba(${config.colorscheme.palette.base0A}FF)
            $cb = rgba(${config.colorscheme.palette.base0B}FF)
            $cc = rgba(${config.colorscheme.palette.base0C}FF)
            $cd = rgba(${config.colorscheme.palette.base0D}FF)
            $ce = rgba(${config.colorscheme.palette.base0E}FF)
            $cf = rgba(${config.colorscheme.palette.base0F}FF)
            # testing some with transparency 99 ~ 60%
            $c099 = rgba(${config.colorscheme.palette.base00}99)
            $c199 = rgba(${config.colorscheme.palette.base01}99)
            $c299 = rgba(${config.colorscheme.palette.base02}99)
            $c399 = rgba(${config.colorscheme.palette.base03}99)
            $c499 = rgba(${config.colorscheme.palette.base04}99)
            $c599 = rgba(${config.colorscheme.palette.base05}99)
            $c699 = rgba(${config.colorscheme.palette.base06}99)
            $c799 = rgba(${config.colorscheme.palette.base07}99)
            $c899 = rgba(${config.colorscheme.palette.base08}99)
            $c999 = rgba(${config.colorscheme.palette.base09}99)
            $ca99 = rgba(${config.colorscheme.palette.base0A}99)
            $cb99 = rgba(${config.colorscheme.palette.base0B}99)
            $cc99 = rgba(${config.colorscheme.palette.base0C}99)
            $cd99 = rgba(${config.colorscheme.palette.base0D}99)
            $ce99 = rgba(${config.colorscheme.palette.base0E}99)
            $cf99 = rgba(${config.colorscheme.palette.base0F}99)
          '';
        };
        #
      };
    })
    #
    (mkIf (cfg.hyprpaper.enable == true) {
      users.users.${spaghetti.user}.packages = [pkgs.hyprpaper];
      home-manager.users.${spaghetti.user} = {
        home.file.".config/hypr/hyprpaper.conf" = {
          text = ''
            preload = /home/${spaghetti.user}/wallpapers/lunar_lake.jpg
            preload = /home/${spaghetti.user}/wallpapers/searise.png
            preload = /home/${spaghetti.user}/wallpapers/fluid_windows.jpg

            # ^ images must be preloaded to display
            wallpaper = , /home/${spaghetti.user}/wallpapers/fluid_windows.jpg
            # ^ any display, directory/file.ext
            splash = false
            # ^ adds splash text to wallpaper
          '';
        };

        home.file.".config/hypr/per-app/hyprpaper.conf" = {
          text = ''
            exec-once = sleep 1 && hyprpaper && sleep 2 && hypridle
            # launch hyprpaper in per-app
            # TODO add an option for hypridle
          '';
        };

        home.file.".config/hypr/hyprlock.conf" = {
          text = ''
            source = ~/.config/hypr/colours.conf

            general {
            hide_cursor = true
            }

            animations {
            enabled = true
            }

            background {
                monitor =
                path = /home/kel/wallpapers/fluid_windows.jpg
                blur_passes = 1
                color = $c1
                brightness = 0.5
                vibrancy = 0.2
                vibrancy_darkness = 0.05
            }

            # time
            label {
                monitor =
                # updates time every 30s
                text = cmd[update:30000] echo "$(date +"%I:%M %p")"
                color = $c5
                font_size = 20
                font_family = Hack Nerd Font Mono
                position = 5, -5
                valign = top
                halign = left
                shadow_passes = 0
            }

            # login
            input-field {
                monitor =
                size = 10000, 40
                outline_thickness = 3
                dots_size = 0.1
                dots_spacing = 0.3
                dots_center = true
                outer_color = $ce
                inner_color = $c2
                font_color = $c5
                rounding = 8
                placeholder_text =
                hide_input = false
                check_color = $cc
                fail_color = $cd
                fail_text =
                fade_on_empty = true
                fade_timeout = 1000
                capslock_color = $cf
                position = 0, 0
                halign = center
                valign = center
                shadow_passes = 0
            }
          '';
        };
        home.file.".config/hypr/hypridle.conf" = {
          text = ''
            general {
                lock_cmd = pidof hyprlock || hyprlock       # avoid starting multiple hyprlock instances.
                before_sleep_cmd = ${pkgs.hyprlock}/bin/hyprlock
                after_sleep_cmd = hyprctl dispatch dpms on  # to avoid having to press a key twice to turn on the display.
            }

            listener {
                timeout = 150                                # 2.5min.
                on-timeout = brightnessctl -s set 10         # set monitor backlight to minimum, avoid 0 on OLED monitor.
                on-resume = brightnessctl -r                 # monitor backlight restore.
            }

            # turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
            #listener {
            #    timeout = 150                                          # 2.5min.
            #    on-timeout = brightnessctl -sd rgb:kbd_backlight set 0 # turn off keyboard backlight.
            #    on-resume = brightnessctl -rd rgb:kbd_backlight        # turn on keyboard backlight.
            #}

            listener {
                timeout = 420                                 # 7min
                on-timeout = loginctl lock-session            # lock screen when timeout has passed
            }

            listener {
                timeout = 330                                 # 5.5min
                on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
                on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
            }

            listener {
                timeout = 900                                # 30min
                on-timeout = systemctl suspend                # suspend pc
            }
          '';
        };
      };
    })
  ];
}
