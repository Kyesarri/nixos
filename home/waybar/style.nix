{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/waybar/style.css" = {
    text = ''
      /*
      modified from
      https://github.com/sameemul-haque/dotfiles
      */

      * {
        border: none;
        border-radius: 0;
        min-height: 0;
        font-family: JetBrainsMono Nerd Font;
        font-size: 14px;
      }

      window#waybar {
        background-color: transparent;
        transition-property: background-color;
        transition-duration: 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.5;
      }

      #workspaces {
        background-color: transparent;
      }

      #workspaces button {
        all: initial;
        min-width: 0;
        box-shadow: inset 0 -3px transparent;
        padding: 6px 18px;
        margin: 6px 3px;
        border-radius: 8px;
        background-color: #${config.colorScheme.palette.base01};
        color: #${config.colorScheme.palette.base05};
      }

      #workspaces button.active {
        color: #${config.colorScheme.palette.base01};
        background-color: #${config.colorScheme.palette.base05};
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #${config.colorScheme.palette.base01};
        background-color: #${config.colorScheme.palette.base05};
      }

      #workspaces button.urgent {
        background-color: #${config.colorScheme.palette.base0D};
      }

      #memory,
      #custom-power,
      #battery,
      #backlight,
      #wireplumber,
      #network,
      #clock,
      #tray {
        border-radius: 8px;
        margin: 6px 3px;
        padding: 6px 12px;
        background-color: #${config.colorScheme.palette.base01};
        color: #${config.colorScheme.palette.base01};
      }

      #custom-power {
        margin-right: 8px;
      }

      #memory {
        background-color: #${config.colorScheme.palette.base0C};
      }

      #battery {
        margin-right: 8px;
        background-color: #${config.colorScheme.palette.base0C};
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #${config.colorScheme.palette.base0D};
        color: #${config.colorScheme.palette.base0F};
      }

      #battery.charging {
        background-color: #${config.colorScheme.palette.base0E};
        color: #${config.colorScheme.palette.base01};
      }

      #backlight {
        background-color: #${config.colorScheme.palette.base0C};
      }

      #wireplumber {
        background-color: #${config.colorScheme.palette.base0C};
      }

      #network {
        background-color: #${config.colorScheme.palette.base0C};
        padding-right: 17px;
      }

      #clock {
        margin-left: 8px;
        font-family: JetBrainsMono Nerd Font;
        background-color: #${config.colorScheme.palette.base0E};
      }

      #custom-power {
        background-color: #${config.colorScheme.palette.base05};
      }

      tooltip {
        border-radius: 8px;
        padding: 45px;
        background-color: #${config.colorScheme.palette.base02};
      }

      tooltip label {
        padding: 15px;
        background-color: #${config.colorScheme.palette.base02};
      }

    '';
  };
}
