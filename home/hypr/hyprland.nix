{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file.".config/hypr/hyprland.conf" = {
    text = ''

       ############################################# spaghetti starts here #############################################

       ############################################# hyprpaper #############################################

       $w1 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/5.jpg"
       $w2 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/6.jpg"
       $w3 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/7.jpg"
       $w4 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/8.jpg"
       $w5 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/5.jpg"
       $w6 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/6.jpg"
       $w7 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/7.jpg"
       $w8 = hyprctl hyprpaper wallpaper "eDP-1,~/nixos/wallpaper/8.jpg"

       ############################################# exec-once #############################################

       exec-once = rog-control-center & hyprpaper & tailscale-systray & waybar # & ags
       exec-once = sleep 4 && gnome-keyring-daemon --start --components=secrets
       exec-once = sleep 6 && dbus-update-activation-environment --all
       exec-once = sleep 2 && copyq --start-server
       exec-once = lxqt-policykit-agent & udiskie &
       exec-once = sleep 8 && poweralertd
       
       # exec-once = ulauncher 

       # exec-once = rm -f /tmp/wcp && mkfifo /tmp/wcp && tail -f /tmp/wcp | wcp -r ~/dots/config/wcp # fifo for wcp
       # exec-once = rm -f /tmp/sovpipe && mkfifo /tmp/sovpipe && tail -f /tmp/sovpipe | sov -t 500 # fifo for sov
       # sov does not work under hypr yet

       ############################################# misc #############################################

       monitor=,1920x1080@120,auto,1

       env = XCURSOR_SIZE,24
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
           sensitivity = 0

           touchpad {
          	natural_scroll = yes
          	disable_while_typing = true
           }
       }


       # $sov1 = echo 1 > /tmp/sovpipe
       # $sov1r = echo 0 > /tmp/sovpipe

      ### define nix-colors here, reduces bulk and increases readability ###

      $c0 = rgba(${config.colorscheme.colors.base00}FF)
      $c1 = rgba(${config.colorscheme.colors.base01}FF)
      $c2 = rgba(${config.colorscheme.colors.base02}FF)
      $c3 = rgba(${config.colorscheme.colors.base03}FF)
      $c4 = rgba(${config.colorscheme.colors.base04}FF)
      $c5 = rgba(${config.colorscheme.colors.base05}FF)
      $c6 = rgba(${config.colorscheme.colors.base06}FF)
      $c7 = rgba(${config.colorscheme.colors.base07}FF)
      $c8 = rgba(${config.colorscheme.colors.base08}FF)
      $c9 = rgba(${config.colorscheme.colors.base09}FF)
      $ca = rgba(${config.colorscheme.colors.base0A}FF)
      $cb = rgba(${config.colorscheme.colors.base0B}FF)
      $cc = rgba(${config.colorscheme.colors.base0C}FF)
      $cd = rgba(${config.colorscheme.colors.base0D}FF)
      $ce = rgba(${config.colorscheme.colors.base0E}FF)
      $cf = rgba(${config.colorscheme.colors.base0F}FF)

       general {
           gaps_in = 5
           gaps_out = 10
           border_size = 5
           resize_on_border = true
           layout = dwindle
           col.active_border = $c0 $ca $c3 $c2 $c1 $c0 90deg
           col.inactive_border = $c0
       }

       decoration {
         rounding = 10
         #multisample_edges = true

         drop_shadow = 1

         shadow_range = 30
         shadow_render_power = 3
         col.shadow = $ca
         col.shadow_inactive= $c0

         active_opacity = 1
         inactive_opacity = .90
         dim_inactive = true
         dim_strength = 0.4

         blur {
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

         ############################################ curves ############################################

         bezier = overshot, 0.34, 1.56, 0.64, 1
         bezier = smoothOut, 0.36, 0, 0.66, -0.56
         bezier = smoothIn, 0.25, 1, 0.5, 1
         bezier = liner, 1, 1, 1, 1

         animation = windows, 1, 5, overshot, slide
         animation = windowsOut, 1, 5, smoothOut, slide
         animation = windowsMove, 1, 5, default
         animation = fade, 1, 5, smoothIn
         animation = fadeDim, 1, 5, smoothIn

         animation = workspaces, 1, 5, default, slide

         animation = border, 1, 5, liner
         animation = borderangle, 1, 360, liner, loop


       }

       ############################################ Layouts ###################################################

       dwindle {
         no_gaps_when_only = false
         pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
         preserve_split = true # you probably want this
         smart_resizing = true
         force_split = 2
       }

       master {
           new_is_master = true
       }

       gestures {
           workspace_swipe = off
       }

       # Example per-device config
       # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
       #device:epic-mouse-v1 {
       #    sensitivity = -0.5
       #}


       ############################################ window rules ############################################

       windowrule = float, title:zsh
       windowrule = float, ^(blueberry.py)$
       windowrule = float, ^(pavucontrol)$
       windowrule = float, ^(org.twosheds.iwgtk)$
       windowrule = float, title:CopyQ
       windowrule = float, title:Authentication Required
       windowrule = tile, ^(lite-xl)$

       ############################################ v2 rules ############################################

       windowrulev2 = opacity 0.8 0.8, class:^(kitty)$
       windowrulev2 = float, size 1000 500, title:btm

       ############################################ binds ############################################

       $mainMod = SUPER

       bind = $mainMod, Q, exec, kitty
       bind = $mainMod, C, killactive,
       bind = $mainMod, M, exit,
       bind = $mainMod, E, exec, nemo
       bind = $mainMod, V, togglefloating,
       bind = $mainMod, R, exec, wofi --show drun
       bind = $mainMod, P, pseudo, # dwindle
       bind = $mainMod, K, exec, lite-xl
       bind = $mainMod, S, exec, steam
       bind = $mainMod, F, exec, firefox
       bind = $mainMod, W, exec, firefox -p work
       bind = control, escape, exec, kitty -e btm
       bind = $mainMod, J, togglesplit, # dwindle
       bind = ,Print, exec, shotman --capture output
       bind = $mainMod, X, exec, dunstctl history-pop


       # bind = $mainMod, X, exec, echo 2 > /tmp/wcp
       # sends commands to wcp fifo, 1 show 2 toggle 3 close

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

       # Switch workspaces with mainMod + [0-9] # was a 21 infront of this, might have been causing issues?
       bind = $mainMod, 1, workspace, 1
       bind = $mainMod, 1, exec, $w1
       # bind = $mainMod, 1, exec, $sov1
       # bindr = $mainMod, 1, exec, $sov1r

       bind = $mainMod, 2, workspace, 2
       bind = $mainMod, 2, exec, $w2

       bind = $mainMod, 3, workspace, 3
       bind = $mainMod, 3, exec, $w3

       bind = $mainMod, 4, workspace, 4
       bind = $mainMod, 4, exec, $w4

       bind = $mainMod, 5, workspace, 5
       bind = $mainMod, 5, exec, $w5

       bind = $mainMod, 6, workspace, 6
       bind = $mainMod, 6, exec, $w6

       bind = $mainMod, 7, workspace, 7
       bind = $mainMod, 7, exec, $w7

       bind = $mainMod, 8, workspace, 8
       bind = $mainMod, 8, exec, $w8

       # Move active window to a workspace with mainMod + SHIFT + [0-9]
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
    '';
  };
}
