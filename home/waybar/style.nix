{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/waybar/style.css" = {
    text = ''
      /*
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
        background-color: #232530;
        color: #CBCED0;
      }

      #workspaces button.active {
        color: #232530;
        background-color: #CBCED0;
      }

      #workspaces button:hover {
        box-shadow: inherit;
        text-shadow: inherit;
        color: #232530;
        background-color: #CBCED0;
      }

      #workspaces button.urgent {
        background-color: #DF5273;
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
        background-color: #232530;
        color: #1C1E26;
      }

      #custom-power {
        margin-right: 8px;
      }

      #memory {
        background-color: #24A8B4;
      }

      #battery {
        margin-right: 8px;
        background-color: #24A8B4;
      }

      #battery.warning,
      #battery.critical,
      #battery.urgent {
        background-color: #DF5273;
        color: #E4A382;
      }

      #battery.charging {
        background-color: #B072D1;
        color: #232530;
      }

      #backlight {
        background-color: #24A8B4;
      }

      #wireplumber {
        background-color: #24A8B4;
      }

      #network {
        background-color: #24A8B4;
        padding-right: 17px;
      }

      #clock {
        margin-left: 8px;
        font-family: JetBrainsMono Nerd Font;
        background-color: #B072D1;
      }

      #custom-power {
        background-color: #CBCED0;
      }

      tooltip {
        border-radius: 8px;
        padding: 45px;
        background-color: #2E303E;
      }

      tooltip label {
        padding: 15px;
        background-color: #2E303E;
      }

    '';
  };
}
