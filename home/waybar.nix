## TODO run eyes over all colours and add-in some from color-nix
{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.programs.waybar = {
    enable = true;
    package = pkgs.waybar.override (oldAttrs: {pulseSupport = true;});
  };
  home-manager.users.kel.home.file.".config/waybar/config.jsonc" = {
    text = ''
      {
        "layer": "top",
        // "output": [],
        "position": "top",
        "height": 36,
        // "width": 900,
        // "margin": "",
        "margin-top": 10,
        "margin-bottom": 0,
        "margin-left": 10,
        "margin-right": 10,
        "spacing": 10,
        "gtk-layer-shell": true,
        "border-radius": 10,

        "clock": {
          "interval": 1,
          "format": " {:%I:%M} ",
          "format-alt": " {:%A, %d %B} ",
          // "on-click": "gnome-calendar",
          "tooltip": true,
          "tooltip-format": "{calendar}",
          "calendar": {
            "mode": "year",
            "mode-mon-col": 3,
            "format": {
              "today": "<span color='#${config.colorScheme.colors.base0F}'>{}</span>"
            }
          }
        },
        "modules-left": [
          "clock",
          "hyprland/workspaces",
          "custom/notification"
        ],
        "modules-center": [
          "hyprland/submap",
          "hyprland/window"
        ],
        "modules-right": [

          // "cpu",
          // "memory",
          "network#wlp2s0",
          "bluetooth",
          "backlight",
          // "pulseaudio#microphone",
          "pulseaudio#audio",
          "battery",

          "tray"
        ],

        "hyprland/workspaces": {
          "format": " {icon} ",
          "format-icons": {
            "default": "󰄰",
            "active": ""
          },
          "on-click": "activate"
        },

        "hyprland/submap": {
          "format": "{}",
          "tooltip": false
        },

        "hyprland/window": {
          "format": " {} ",
          "separate-outputs": false
        },

        "tray": {
          "icon-size": 15,
          "spacing": 10
        },

        "cpu": {
          "format": " {usage}%",
          "on-click": "",
          "tooltip": false
        },

        "memory": {
          "format": "󰍛 {used:0.1f}GB ({percentage}%) / {total:0.1f}GB",
          "on-click": "",
          "tooltip": false
        },

        "backlight": {
          "format": " {icon} {percent} ",
          "format-icons": [
            "󰃟"
          ],
          "on-scroll-up": "brightnessctl set +1%",
          "on-scroll-down": "brightnessctl set 1%-",
          "on-click": "brightnessctl set 0",
          "tooltip": false
        },

      	"pulseaudio#audio": {
      		"format": " {icon} {volume:2} ",
      		"format-bluetooth": " {icon} {volume}%  ",
      		"format-muted": " {icon} Muted ",
      		"format-icons": {
      			"headphones": "",
      			"default": [
      				"",
      				""
      			]
      		},
      		"scroll-step": 5,
      		"on-click": "pavucontrol",
      		"on-click-right": "pamixer -t"
      	},

        "network#wlp2s0": {
          "interval": 1,
          "interface": "wlan0",
          "format-icons": [
            "󰤯",
            "󰤟",
            "󰤢",
            "󰤥",
            "󰤨"
          ],
          "format-wifi": " {icon}  ", // added multiple spaces to the right, was not aligning center correctly, still is not :(
          "format-disconnected": "󰤮",
          "on-click": "iwgtk",
          "tooltip": true,
          "tooltip-format": "󰢮 {ifname}\n󰩟 {ipaddr}/{cidr}\n{icon} {essid}\n󱑽 {signalStrength}% {signaldBm} dBm {frequency} MHz\n󰞒 {bandwidthDownBytes}\n󰞕 {bandwidthUpBytes}"
        },

        "bluetooth": {
          "format-disabled": "   ",
          "format-off": "   ",
          "format-on": " 󰂯 ",
          "format-connected": " 󰂯 ",
          "format-connected-battery": " 󰂯 ",
          "tooltip-format-connected": " {device_alias} 󰂄{device_battery_percentage} ",
          "on-click": "blueberry",
          "tooltip": true
        },

        "battery": {
          "states": {
            "warning": 20,
            "critical": 10
          },

          "format": " {icon} {capacity} ",
          "format-charging": " 󰂄 {capacity} ",
          "format-plugged": " 󱘖 {capacity} ",
          "format-icons": [
            "󰁺",
            "󰁻",
            "󰁼",
            "󰁽",
            "󰁾",
            "󰁿",
            "󰂀",
            "󰂁",
            "󰂂",
            "󰁹"
          ],
          "on-click": "",
          "tooltip": false
        }
      }

    '';
  };
  home-manager.users.kel.home.file.".config/waybar/style.css" = {
    text = ''
      * {
          font-size: 14px;
          font-family: "Hasklug Nerd Font";
          border-radius: 10;
      }

      window#waybar {
        background-color: transparent;
        color: #${config.colorScheme.colors.base05};
        /* border-radius: 20px; */
        /* border: 1px solid #${config.colorScheme.colors.base00}; */
      }

      tooltip {
        background: #${config.colorScheme.colors.base00};
        border: 1px solid #${config.colorScheme.colors.base05};
        border-radius: 10px;
      }
      tooltip label {
        color: #${config.colorScheme.colors.base05};
      }

      #workspaces {
        background-color: transparent;
        margin-top: 0;
        margin-bottom: 0;
      }

      #workspaces button {
        background-color: #${config.colorScheme.colors.base00};
        color: #${config.colorScheme.colors.base05};
        border-radius: 10px;
        transition: all 0.3s ease;
        margin-right: 10;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        background-color: #${config.colorScheme.colors.base04};
        color: #${config.colorScheme.colors.base09};
        min-width: 30px;
        transition: all 0.3s ease;
      }

      #workspaces button.focused,
      #workspaces button.active {
        background-color: #${config.colorScheme.colors.base02};
        color: #${config.colorScheme.colors.base09};
        min-width: 30px;
        transition: all 0.3s ease;
        animation: colored-gradient 10s ease infinite;
      }

      /* #workspaces button.focused:hover,
      #workspaces button.active:hover {
        background-color: #${config.colorScheme.colors.base09};
        transition: all 1s ease;
      } */

      #workspaces button.urgent {
        background-color: #${config.colorScheme.colors.base0F};
        color: #${config.colorScheme.colors.base00};
        transition: all 0.3s ease;
      }

      /* #workspaces button.hidden {} */

      #taskbar {
        border-radius: 8px;
        margin-top: 4px;
        margin-bottom: 4px;
        margin-left: 1px;
        margin-right: 1px;
      }

      #taskbar button {
        color: #${config.colorScheme.colors.base05};
        padding: 1px 8px;
        margin-left: 1px;
        margin-right: 1px;
      }

      #taskbar button:hover {
        background: transparent;
        border: 1px solid #${config.colorScheme.colors.base02};
        border-radius: 8px;
        transition: all 0.3s ease;
        animation: colored-gradient 10s ease infinite;
      }

      /* #taskbar button.maximized {} */

      /* #taskbar button.minimized {} */

      #taskbar button.active {
        border: 1px solid #${config.colorScheme.colors.base02};
        border-radius: 8px;
        transition: all 0.3s ease;
        animation: colored-gradient 10s ease infinite;
      }

      /* #taskbar button.fullscreen {} */

      /* -------------------------------------------------------------------------------- */

      #custom-launcher,
      /* #window, */
      #submap
      #mode,
      /* #tray, */
      #cpu,
      #memory,
      #backlight,
      #window  { background-color: #${config.colorScheme.colors.base00}; }
      #pulseaudio.audio { background-color: #${config.colorScheme.colors.base00}; }
      #pulseaudio.microphone,
      #network { background-color: #${config.colorScheme.colors.base00}; }
      #bluetooth  { background-color: #${config.colorScheme.colors.base00}; }
      #battery  { background-color: #${config.colorScheme.colors.base00}; }
      #clock { background-color: #${config.colorScheme.colors.base00}; }
      #custom-powermenu,

      #custom-notification {
        background-color: transparent;
        color: #${config.colorScheme.colors.base05};
        padding: 1px 8px;
        margin-top: 5px;
        margin-bottom: 5px;
        margin-left: 2px;
        margin-right: 2px;
        border-radius: 20px;
        transition: all 0.3s ease;
      }

      #submap {
        background-color: #${config.colorScheme.colors.base00};
        border: 0;
      }

      /* If workspaces is the leftmost module, omit left margin */
      /* .modules-left > widget:first-child > #workspaces, */
      .modules-left > widget:first-child > #workspaces button,
      .modules-left > widget:first-child > #taskbar button,
      .modules-left > widget:first-child > #custom-launcher,
      .modules-left > widget:first-child > #window,
      .modules-left > widget:first-child > #tray,
      .modules-left > widget:first-child > #cpu,
      .modules-left > widget:first-child > #memory,
      .modules-left > widget:first-child > #backlight,
      .modules-left > widget:first-child > #pulseaudio.audio,
      .modules-left > widget:first-child > #pulseaudio.microphone,
      .modules-left > widget:first-child > #network,
      .modules-left > widget:first-child > #bluetooth,
      .modules-left > widget:first-child > #battery,
      .modules-left > widget:first-child > #clock,
      .modules-left > widget:first-child > #custom-powermenu,
      .modules-left > widget:first-child > #custom-notification {
        margin-left: 5px;
      }

      /* If workspaces is the rightmost module, omit right margin */
      /* .modules-right > widget:last-child > #workspaces, */
      /* .modules-right > widget:last-child > #workspaces, */
      .modules-right > widget:last-child > #workspaces button,
      .modules-right > widget:last-child > #taskbar button,
      .modules-right > widget:last-child > #custom-launcher,
      .modules-right > widget:last-child > #window,
      .modules-right > widget:last-child > #tray,
      .modules-right > widget:last-child > #cpu,
      .modules-right > widget:last-child > #memory,
      .modules-right > widget:last-child > #backlight,
      .modules-right > widget:last-child > #pulseaudio.audio,
      .modules-right > widget:last-child > #pulseaudio.microphone,
      .modules-right > widget:last-child > #network,
      .modules-right > widget:last-child > #bluetooth,
      .modules-right > widget:last-child > #battery,
      .modules-right > widget:last-child > #clock,
      .modules-right > widget:last-child > #custom-powermenu,
      .modules-right > widget:last-child > #custom-notification {
        margin-right: 5px;
      }

      /* -------------------------------------------------------------------------------- */

      #tray {
        background-color: #${config.colorScheme.colors.base00};
        padding: 1px 8px;
      }
      #tray > .passive {
        -gtk-icon-effect: dim;
      }
      #tray > .needs-attention {
        -gtk-icon-effect: highlight;
        background-color: #${config.colorScheme.colors.base0F};
      }

    '';
  };
}
