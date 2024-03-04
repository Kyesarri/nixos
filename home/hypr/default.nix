{
  lib,
  pkgs,
  config,
  spaghetti,
  inputs,
  ...
}:
with lib; let
  cfg = config.gnocchi.hypr; # shorthand some lines
in {
  # wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
  # libmkafter looks vvv interesting
  options.gnocchi = {
    hypr = {
      enable = mkEnableOption "enable hyprland"; # will be gnocchi.hypr.enable = true; in host.nix
      hyprpaper.enable = mkEnableOption "enable hyprpaper with config, can do type of, and set source dir?";
      animations.enable = mkEnableOption "enable hypr animations";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      #
      programs.hyprland.enable = true; # enable hyprland, needed w below?
      home-manager.users.${spaghetti.user} = {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = true;
          plugins = [inputs.hy3.packages.x86_64-linux.hy3];
          extraConfig = ''
            ${builtins.readFile ./hyprland.conf}
          '';
        };
        # add nix-colors
        home.file.".config/hypr/colours.conf" = {
          text = ''
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
          '';
        };
        #
        # break for humans
        #
        home.file.".config/hypr/hyprland.conf" = {
          text = ''
            ############################################# spaghetti starts here #############################################
            $mainMod = SUPER

            # import nix-colors
            source = ~/.config/hypr/colours.conf

            ############################################# exec-once #############################################
            exec-once = sleep 4 && gnome-keyring-daemon --start --components = pkcs11, secrets, ssh

            # move above to seahorse below /home or /services/ unsure about below as its not really machine or software specific yet :)

            exec-once = sleep 6 && dbus-update-activation-environment --all
            exec-once = lxqt-policykit-agent & udiskie

            ############################################# per-device #############################################
            ## per-device config, from ./hosts/hostname/per-device.nix ##
            source = ~/.config/hypr/per-device.conf
            ## NOTE this is configured in /hosts/foo/per-device.nix

            ############################################# env #############################################
            env = XCURSOR_SIZE,20
            env = WLR_NO_HARDWARE_CURSORS,1

            ############################################# misc #############################################
            misc {
                disable_hyprland_logo = true
                disable_splash_rendering = true
                mouse_move_enables_dpms = true
                key_press_enables_dpms = true
                vfr = true
                allow_session_lock_restore = true
                render_ahead_safezone = 1
                background_color = #000000
                # ^ can only use a single colour
            }
            ############################################# input #############################################
            input {
                kb_layout = us
                kb_variant =
                kb_model =
                kb_options =
                kb_rules =
                follow_mouse = 1
                repeat_delay = 300
                repeat_rate = 50
                sensitivity = 0
                # fixed touchpad, needed indentation to work correctly :)
                touchpad {
                    natural_scroll = yes
                    disable_while_typing = true
                }
            }

            ############################################# general #############################################
            # TODO might want a source = ~/.config/hypr/general.conf +
            # source = ~/.config/hypr/decoration.conf
            general {
                gaps_in = 5
                gaps_out = 10
                border_size = 3
                resize_on_border = true
                layout = dwindle
                col.active_border = $c0 $c1 $c1 $c2 $c1 $c0
                col.inactive_border = $c0 $c1

                layout = hy3

                # TODO below are the fancier settings with coloured borders, with animations
                # border_size = 5
                # col.active_border = $c0 $ca $c3 $c2 $c1 $c0 90deg
                # col.inactive_border = $c0 $c1 90deg
            }

            ############################################# decoration see TODO below #############################################
            decoration {
                # drop_shadow = 1
                # shadow_range = 30
                # shadow_render_power = 3
                # removing shadows, favour none for a more minimal look currently
                # TODO pile, nix mkOption for different theme settings :)

                drop_shadow = 0
                shadow_range = 0
                shadow_render_power = 0
                col.shadow = $ca
                col.shadow_inactive= $c0
                rounding = 10
                #
                # # testing nix-colors tweaks # # TODO Review / mkOption this
                #
                active_opacity = 1
                inactive_opacity = 1
                dim_inactive = false
                dim_strength = 1
                #
                # # testing nix-colors tweaks # #
                #
                # inactive_opacity = .90
                # dim_inactive = true
                # dim_strength = 0.4
                blur {
                    vibrancy = 0.25
                    vibrancy_darkness = 0.25
                    enabled = true
                    size = 5
                    passes = 1
                    noise = 0
                    brightness = 0.5
                    new_optimizations = true
                }
            }

            ############################################ animations ############################################
            animations {
                enabled = true
                bezier = overshot, 0.34, 1.56, 0.64, 1
                bezier = smoothOut, 0.36, 0, 0.66, -0.56
                bezier = smoothIn, 0.25, 1, 0.5, 1
                bezier = liner, 1, 1, 1, 1
                bezier = cubic, 0.785, 0.135, 0.15, 0.86
                bezier = snappy, 0.51, 0.93, 0, 1

                animation = windows, 1, 5, overshot, slide
                animation = windowsOut, 1, 5, smoothOut, slide
                animation = windowsMove, 1, 5, snappy
                animation = fade, 1, 5, smoothIn
                animation = fadeDim, 1, 5, smoothIn
                animation = workspaces, 1, 5, snappy, slide
                animation = border, 1, 5, liner # change window focus
                animation = borderangle, 1, 360, liner, loop # to animate border
            }

            ############################################ Layouts ###################################################
            dwindle {
                no_gaps_when_only = false
                pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
                preserve_split = true # you probably want this
                smart_resizing = false
                force_split = 2
            }

            master {
                new_is_master = false
            }

            ############################################ binds ############################################
            # move to gscreenshot under home, TODO #
            ## take fullscreen screenshot and send to /user/screenshots/
            bind = ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/screenshot_$hx$w_%Y-%m-%d%M-%S.png' -n
            ## open screenshot selection tool with overlay, once region selected send to /user/screenshots/
            bind = shift ,Print, exec, gscreenshot -f '/home/${spaghetti.user}/screenshots/snip_$hx$w_%Y-%m-%d%M-%S.png' -n -s

            bind = $mainMod, S, exec, ~/nixos/scripts/dunst/hyprpicker.sh
            # not working, check script TODO changed above from bash to nothing

            # sound
            binde = , xf86audioraisevolume, exec, ~/nixos/scripts/dunst/pipewire.sh up
            binde = , xf86audiolowervolume, exec, ~/nixos/scripts/dunst/pipewire.sh down

            # brightness
            ## screen
            binde = , XF86MonBrightnessUp, exec, ~/nixos/scripts/dunst/brightnessctl.sh up
            binde = , XF86MonBrightnessDown, exec, ~/nixos/scripts/dunst/brightnessctl.sh down

            ## keyboard
            binde = , XF86KbdBrightnessUp, exec, ~/nixos/scripts/dunst/asusctl.sh up
            binde = , XF86KbdBrightnessDown, exec, ~/nixos/scripts/dunst/asusctl.sh down

            # workspace
            bind = $mainMod, C, killactive,
            bind = $mainMod, M, exit,
            bind = $mainMod, E, exec, nemo
            bind = $mainMod, V, togglefloating,
            bind = $mainMod, P, pseudo, dwindle
            bind = $mainMod, J, togglesplit, # dwindle

            # Move focus with mainMod + arrow keys
            # FIXME add hy3:movefocus once working
            bind = $mainMod, left, movefocus, l
            bind = $mainMod, right, movefocus, r
            bind = $mainMod, up, movefocus, u
            bind = $mainMod, down, movefocus, d

            # Switch workspaces with mainMod + [0-9]
            ## added switching wallpapers on workspace switch
            bind = $mainMod, 1, workspace, 1
            bind = $mainMod, 2, workspace, 2
            bind = $mainMod, 3, workspace, 3
            bind = $mainMod, 4, workspace, 4
            bind = $mainMod, 5, workspace, 5
            bind = $mainMod, 6, workspace, 6
            bind = $mainMod, 7, workspace, 7
            bind = $mainMod, 8, workspace, 8
            bind = $mainMod, 9, workspace, 9
            bind = $mainMod, 0, workspace, 10

            # Move active window to a workspace with mainMod + SHIFT + [0-9]
            bind = $mainMod SHIFT, 1, movetoworkspace, 1
            bind = $mainMod SHIFT, 2, movetoworkspace, 2
            bind = $mainMod SHIFT, 3, movetoworkspace, 3
            bind = $mainMod SHIFT, 4, movetoworkspace, 4
            bind = $mainMod SHIFT, 5, movetoworkspace, 5
            bind = $mainMod SHIFT, 6, movetoworkspace, 6
            bind = $mainMod SHIFT, 7, movetoworkspace, 7
            bind = $mainMod SHIFT, 8, movetoworkspace, 8
            bind = $mainMod SHIFT, 9, movetoworkspace, 9
            bind = $mainMod SHIFT, 0, movetoworkspace, 10

            # Scroll through existing workspaces with mainMod + scroll
            bind = $mainMod, mouse_down, workspace, e+1
            bind = $mainMod, mouse_up, workspace, e-1

            # Move/resize windows with mainMod + LMB/RMB and dragging
            bindm = $mainMod, mouse:272, movewindow
            bindm = $mainMod, mouse:273, resizewindow

            ############################################# per-app #############################################
            ## wildcard per-app enabled in each ./home/app*/*.nix ##
            source = ~/.config/hypr/per-app/*.conf

            plugin {
              hy3 {
                # disable gaps when only one window is onscreen
                no_gaps_when_only = true

                # policy controlling what happens when a node is removed from a group,
                # leaving only a group
                # 0 = remove the nested group
                # 1 = keep the nested group
                # 2 = keep the nested group only if its parent is a tab group
                node_collapse_policy = 2

                # policy controlling what windows will be focused using `hy3:movefocused`
                # 0 = focus strictly by layout, don't attempt to skip windows that are obscured by another one
                # 1 = do not focus windows which are entirely obscured by a floating window
                # 2 = when `hy3:movefocus` layer is `samelayer` then use focus policy 0 (focus strictly by layout)
                #     when `hy3:movefocus` layer is `all` then use focus policy 1 (don't focus obscured windows)
                focus_obscured_windows_policy = 2

                # which layers should be considered when changing focus with `hy3:movefocus`?
                # samelayer = only focus windows on same layer as the source window (floating or tiled)
                # all       = choose the closest window irrespective of the layout
                # tiled     = only choose tiled windows, not especially useful but permitted by parser
                # floating  = only choose floating windows, not especially useful but permitted by parser
                default_movefocus_layer = samelayer

                # offset from group split direction when only one window is in a group
                group_inset = 10

                # if a tab group will automatically be created for the first window spawned in a workspace
                tab_first_window = true

                # tab group settings
                tabs {
                  # height of the tab bar
                  height = 15

                  # padding between the tab bar and its focused node
                  padding = 5

                  # the tab bar should animate in/out from the top instead of below the window
                  from_top = false

                  # rounding of tab bar corners
                  rounding = 3

                  # render the window title on the bar
                  render_text = true

                  # center the window title
                  text_center =false

                  # font to render the window title with
                  text_font = Sans

                  # height of the window title
                  text_height = 8

                  # left padding of the window title
                  text_padding = 3

                  # active tab bar segment color
                  col.active = 0xff32b4ff

                  # urgent tab bar segment color
                  col.urgent = 0xffff4f4f

                  # inactive tab bar segment color
                  col.inactive = 0x80808080

                  # active tab bar text color
                  col.text.active = 0xff000000

                  # urgent tab bar text color
                  col.text.urgent = 0xff000000

                  # inactive tab bar text color
                  col.text.inactive = 0xff000000
                }

                # autotiling settings
                autotile {
                  # enable autotile
                  enable = false

                  # make autotile-created groups ephemeral
                  ephemeral_groups = true

                  # if a window would be squished smaller than this width, a vertical split will be created
                  # -1 = never automatically split vertically
                  # 0 = always automatically split vertically
                  # <number> = pixel height to split at
                  trigger_width = 0

                  # if a window would be squished smaller than this height, a horizontal split will be created
                  # -1 = never automatically split horizontally
                  # 0 = always automatically split horizontally
                  # <number> = pixel height to split at
                  trigger_height = 0

                  # a space or comma separated list of workspace ids where autotile should be enabled
                  # it's possible to create an exception rule by prefixing the definition with "not:"
                  # workspaces = 1,2 # autotiling will only be enabled on workspaces 1 and 2
                  # workspaces = not:1,2 # autotiling will be enabled on all workspaces except 1 and 2
                  workspaces = all
                }
              }
            }

          '';
        };
      };
    })
    #
    # break for humans
    # make if hypr + hyprpaper are enabled
    #
    (mkIf (cfg.enable || cfg.hyprpaper.enable) {
      users.users.${spaghetti.user}.packages = [pkgs.hyprpaper];
      home-manager.users.${spaghetti.user} = {
        home.file.".config/hypr/hyprpaper.conf" = {
          text = ''
            preload = /home/${spaghetti.user}/wallpapers/1.jpg
            preload = /home/${spaghetti.user}/wallpapers/2.jpg
            preload = /home/${spaghetti.user}/wallpapers/3.jpg
            preload = /home/${spaghetti.user}/wallpapers/4.jpg
            preload = /home/${spaghetti.user}/wallpapers/5.png
            # ^ images must be preloaded to display
            wallpaper = , /home/${spaghetti.user}/wallpapers/5.png
            # ^ any display, directory/image.extension
            splash = false
          '';
        };
        home.file.".config/hypr/per-app/hyprpaper.conf" = {
          text = ''
            exec-once = sleep 2 && hyprpaper
            # launch hyprpaper in per-app
          '';
        };
      };
    })
  ];
}
