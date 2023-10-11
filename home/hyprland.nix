{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."dots/config/hypr/hyprland.conf" = {
    # wondering if I can use     extraConfig = lib.fileContents ./hyprland.conf; and still have the colors
    # passed through to my hyprland config, otherwise have nix build a color chart and import via
    # symlinked hyprland.conf
    #
    # this writes below contents to the above dots/config/hypr/hyprland.conf file
    # change to .config if you have not modified your xdg config dir
    text = ''
      $w1 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/1.jpg"
      $w2 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/2.jpg"
      $w3 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/3.jpg"
      $w4 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/4.jpg"

      exec-once = waybar & rog-control-center & hyprpaper & tailscale-systray
      exec-once = gnome-keyring-daemon --start --components=secrets
      exec-once = dbus-update-activation-environment --all
      exec-once = sleep 2 && copyq --start-server & kdeconnect-indicator
      exec-once = rm -f /tmp/wcp && mkfifo /tmp/wcp && tail -f /tmp/wcp | wcp -r ~/dots/config/wcp # fifo for wcp

      monitor=,1920x1080@120,auto,1

      env = XCURSOR_SIZE,36
      env = WLR_NO_HARDWARE_CURSORS,1

      misc {
        disable_hyprland_logo = true
        disable_splash_rendering = true
        mouse_move_enables_dpms = true
        key_press_enables_dpms = true
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

          touchpad {
      	natural_scroll = yes
      	disable_while_typing = true
          }

          sensitivity = 0
      }

      general {

          gaps_in = 5
          gaps_out = 10
          border_size = 5
          resize_on_border = true
          layout = dwindle
          col.active_border = rgba(${config.colorscheme.colors.base01}FF) rgba(${config.colorscheme.colors.base02}FF) rgba(${config.colorscheme.colors.base03}FF) 3deg
          col.inactive_border = rgba(${config.colorscheme.colors.base00}FF)
      }

      decoration {
          rounding = 10
          multisample_edges = true
          blur {
      	enabled = true
      	size = 5
      	passes = 1
      	noise = 0
      	brightness = 0.5
      	new_optimizations = true
          }

          drop_shadow = no
          shadow_range = 0
          shadow_render_power = 3
          col.shadow = rgba(${config.colorscheme.colors.base00}ee)
          active_opacity = 1
          inactive_opacity = .95
          dim_inactive = true
          dim_strength = 0.4
      }

      ############################################# Animations ###############################################

      animations {
        enabled = true

      ############################################# Bezier Curve #############################################

        bezier = overshot, 0.05, 0.9, 0.1, 1.05
        bezier = smoothOut, 0.36, 0, 0.66, -0.56
        bezier = smoothIn, 0.25, 1, 0.5, 1

        animation = windows, 1, 3, overshot, slide
        animation = windowsOut, 1, 3, smoothOut, slide
        animation = windowsMove, 1, 3, default
        animation = border, 1, 3, default
        animation = fade, 1, 3, smoothIn
        animation = fadeDim, 1, 3, smoothIn
        animation = workspaces, 1, 3, default

      }

      ############################################ Layouts ###################################################

      dwindle {
        no_gaps_when_only = false
        pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = true # you probably want this
      }

      master {
          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          new_is_master = true
      }

      gestures {
          # See https://wiki.hyprland.org/Configuring/Variables/ for more
          workspace_swipe = off
      }

      # Example per-device config
      # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
      device:epic-mouse-v1 {
          sensitivity = -0.5
      }


      windowrule = float, ^(kitty)$
      windowrule = float, title:Bluetooth
      windowrule = float, title:Volume Control
      windowrule = float, title:Network Connections
      windowrule = float, title:CopyQ

      windowrulev2 = opacity 0.8 0.8,class:^(kitty)$

      # See https://wiki.hyprland.org/Configuring/Keywords/ for more
      $mainMod = SUPER

      # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
      bind = $mainMod, Q, exec, kitty
      bind = $mainMod, C, killactive,
      bind = $mainMod, M, exit,
      bind = $mainMod, E, exec, nemo
      bind = $mainMod, V, togglefloating,
      bind = $mainMod, R, exec, wofi --show drun
      bind = $mainMod, P, pseudo, # dwindle
      bind = $mainMod, K, exec, codium --disable-gpu
      bind = $mainMod, S, exec, steam
      bind = $mainMod, F, exec, firefox
      bind = $mainMod, W, exec, firefox -p work
      bind = control, escape, exec, kitty -e btm
      bind = $mainMod, J, togglesplit, # dwindle
      bind = ,Print, exec, shotman --capture output
      bind = $mainMod, X, exec, echo 2 > /tmp/wcp
      # sends commands to wcp fifo, 2 is toggle, wonder how large that file can get during one session :D

      # sound
      binde = , xf86audioraisevolume, exec, pamixer -i 3 @DEFAULT_SINK@
      binde = , xf86audiolowervolume, exec, pamixer -d 3 @DEFAULT_AUDIO_SINK@

      # brightness

      ## screen
      binde = , XF86MonBrightnessDown, exec, brightnessctl set 3%-
      binde = , XF86MonBrightnessUp, exec, brightnessctl set 3%+
      ## keyboard



      # Move focus with mainMod + arrow keys
      bind = $mainMod, left, movefocus, l
      bind = $mainMod, right, movefocus, r
      bind = $mainMod, up, movefocus, u
      bind = $mainMod, down, movefocus, d

      21# Switch workspaces with mainMod + [0-9]
      bind = $mainMod, 1, workspace, 1
      bind = $mainMod, 1, exec, $w1
      bind = $mainMod, 2, workspace, 2
      bind = $mainMod, 2, exec, $w2
      bind = $mainMod, 3, workspace, 3
      bind = $mainMod, 3, exec, $w3
      bind = $mainMod, 4, workspace, 4
      bind = $mainMod, 4, exec, $w4
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

    '';
  };
}
