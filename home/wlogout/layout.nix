{user, ...}: {
  home-manager.users.${user}.home.file.".config/wlogout/layout" = {
    text = ''
      {
          "label" : "lock",
          "action" : "sleep 0.4 && swaylock --screenshots --effect-blur 3x5 --fade-in 1 --effect-vignette 0.1:0.8",
          "text" : "",
          "keybind" : "l"
      }
      {
          "label" : "reboot",
          "action" : "dunstify -a wlogout \"rebooting in 5, please wait\" -u 2 && sleep 5 && systemctl reboot",
          "text" : "󰜉",
          "keybind" : "r"
      }
      {
          "label" : "shutdown",
          "action" : "systemctl poweroff",
          "text" : "󰐥",
          "keybind" : "s"
      }
      {
          "label" : "logout",
          "action" : "hyprctl dispatch exit 0",
          "text" : "󰍃",
          "keybind" : "e"
      }
      {
          "label" : "suspend",
          "action" : "systemctl suspend",
          "text" : "󱖒",
          "keybind" : "u"
      }
      {
          "label" : "gem",
          "action" : "sleep 0.4 && dunstify -a wlogout -h gem activated",
          "text" : "󰮋",
          "keybind" : "q"
      }
    '';
  };
}
