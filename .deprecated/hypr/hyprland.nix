{
  config,
  inputs,
  outputs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/hyprland.conf" = {
    text = ''
      ############################################# spaghetti starts here #############################################
      $mainMod = SUPER

      # TODO add colours here, move all nix-colors to that file then import
      ## source = ~/.config/hypr/colours.conf

      ############################################# hyprpaper #############################################

      # move to wallpaper per device and import
      ## source = ~/.config/hypr/wallpaper.conf

      ## might want a function that pulls a wallpaper at random rather than having specific per desktop
      #$w1 = hyprctl hyprpaper wallpaper "eDP-1,~/wallpaper/1.jpg"
      #$w2 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/2.jpg"
      #$w3 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/3.jpg"
      #$w4 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/4.jpg"
      #$w5 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/5.jpg"
      #$w6 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/6.jpg"
      #$w7 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/7.jpg"
      #$w8 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/8.jpg"

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

      ## exec-once ##

      ## TODO move to /home/
      exec-once = hyprpaper

      exec-once = sleep 4 && gnome-keyring-daemon --start --components = pkcs11, secrets, ssh
      # move above to seahorse below /home or /services/ unsure about below as its not really machine or software specific yet :)
      exec-once = sleep 6 && dbus-update-activation-environment --all
      exec-once = lxqt-policykit-agent & udiskie

      ## per-device config, from ./hosts/hostname/per-device.nix ##
      source = ~/.config/hypr/per-device.conf

      env = XCURSOR_SIZE,20
      env = WLR_NO_HARDWARE_CURSORS,1

      misc {
          disable_hyprland_logo = true
          disable_splash_rendering = true
          mouse_move_enables_dpms = true
          key_press_enables_dpms = true
          vfr = true
          allow_session_lock_restore = true
          render_ahead_safezone = 1
          background_color = #000000
          # can only use a single colour
      }

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

      general {
          gaps_in = 5
          gaps_out = 10
          border_size = 3
          resize_on_border = true
          layout = dwindle
          col.active_border = $c0 $c1 $c1 $c2 $c1 $c0
          col.inactive_border = $c0 $c1
          # border_size = 5
          # col.active_border = $c0 $ca $c3 $c2 $c1 $c0 90deg
          # col.inactive_border = $c0 $c1 90deg
      }

      decoration {
          # drop_shadow = 1
          # shadow_range = 30
          # shadow_render_power = 3
          # removing shadows, favour none for a more minimal look currently
          # add to the TODO pile, nix mkOption for different theme settings :)
          drop_shadow = 0
          shadow_range = 0
          shadow_render_power = 0
          col.shadow = $ca
          col.shadow_inactive= $c0
          rounding = 10
          #
          # # testing nix-colors tweaks # #
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
      ## not working, check script TODO changed above from bash to nothing

      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, nemo
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, P, pseudo, dwindle
      bind = $mainMod, J, togglesplit, # dwindle

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

      # Move focus with mainMod + arrow keys
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
      ## should add a hyprpaper workspace wallpaper switch here too :)
      bind = $mainMod SHIFT, 1, movetoworkspace, 1
      bind = $mainMod SHIFT, 2, movetoworkspace, 2
      bind = $mainMod SHIFT, 3, movetoworkspace, 3
      bind = $mainMod SHIFT, 4, movetoworkspace, 4
      bind = $mainMod SHIFT, 5, movetoworkspace, 5
      bind = $mainMod SHIFT, 6, movetoworkspace, 6
      bind = $mainMod SHIFT, 7, movetoworkspace, 7
      bind = $mainMod SHIFT, 8, movetoworkspace, 8

      # Scroll through existing workspaces with mainMod + scroll
      bind = $mainMod, mouse_down, workspace, e+1
      bind = $mainMod, mouse_up, workspace, e-1

      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = $mainMod, mouse:272, movewindow
      bindm = $mainMod, mouse:273, resizewindow

      ## wildcard per-app enabled in each ./home/app*/*.nix ##
      source = ~/.config/hypr/per-app/*.conf
    '';
  };
}
