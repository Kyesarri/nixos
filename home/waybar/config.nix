{spaghetti, ...}: {
  home-manager.users.${spaghetti.user}.home.file.".config/waybar/config" = {
    text = ''
      {
          "layer": "top",
          "position": "top",
          "spacing": 5,
          "height": 40,
          "gtk-layer-shell": true,
          "margin-right": 5,
          "margin-left": 5,
          "margin-bottom": 0,
          "margin-top": 5,
          "margin": 5,

          "modules-left": [
              "clock",
              "hyprland/workspaces"
          ],

          "modules-center": [
          ],

          "modules-right": [
              "tray",
              "memory",
              "network",
              "wireplumber",
              "battery"
          ],

          "hyprland/workspaces": {
              "on-click": "activate",
              "format": "{icon}",
              "format-icons": {
                  "default": "",
                  "1": "1",
                  "2": "2",
                  "3": "3",
                  "4": "4",
                  "5": "5",
                  "6": "6",
                  "7": "7",
                  "8": "8",
                  "9": "9",
                  "active": "󱓻",
                  "urgent": "󱓻"
              },
              "persistent_workspaces": {
                  "1": [],
                  "2": [],
                  "3": [],
                  "4": [],
                  "5": []
              }
          },
          "memory": {
              "interval": 5,
              "format": "󰍛 {}%",
              "max-length": 10
          },
          "tray": {
              "spacing": 10
          },
          "clock": {
              "tooltip-format": "{calendar}",
              "format": "{:%I:%M}",
              "format-alt": "{:%A, %d %B}"
          },
          "network": {
              "format-wifi" : "{icon}",
              "format-icons": ["󰣾","󰣴","󰣶","󰣸","󰣺"],
              "format-ethernet": "󰀂",
      	"format-alt" : "󱛇",
              "format-disconnected" : "󰖪",
      	"tooltip-format-wifi": "{icon} {essid}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
              "tooltip-format-ethernet": "󰀂  {ifname}\n⇣{bandwidthDownBytes}  ⇡{bandwidthUpBytes}",
      	"tooltip-format-disconnected": "Disconnected",
      	"interval": 5,
      	"nospacing": 1
          },
          "wireplumber": {
              "format": "{icon}",
              "format-bluetooth": "󰂰",
              "nospacing": 1,
              "tooltip-format": "Volume : {volume}%",
              "format-muted": "󰝟",
              "format-icons": {
                  "headphone": "",
                  "default": ["󰕿","󰖀","󰕾"]
              },
              "on-click": "pamixer -t",
              "scroll-step": 1
          },
          "battery": {
              "format": "{capacity}% {icon}",
              "format-icons": {
                  "charging": [
                      "󰢜",
                      "󰂆",
                      "󰂇",
                      "󰂈",
                      "󰢝",
                      "󰂉",
                      "󰢞",
                      "󰂊",
                      "󰂋",
                      "󰂅"
                  ],
                  "default": [
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
                  ]
              },
              "format-full": "Charged ",
              "interval": 5,
              "states": {
                  "warning": 20,
                  "critical": 10
              },
              "tooltip": false
          }
      }
    '';
  };
}
