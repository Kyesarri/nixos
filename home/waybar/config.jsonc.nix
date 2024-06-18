{
  config,
  inputs,
  outputs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/waybar/config.jsonc" = {
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
              "today": "<span color='#${config.colorScheme.palette.base0F}'>{}</span>"
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
          "format-disabled": " 󰂲 ",
          "format-off": " 󰂲 ",
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
}
