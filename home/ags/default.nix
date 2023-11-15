{ config, inputs, outputs, lib, pkgs, ... }: {

  home-manager.users.kel.programs.ags = {
    enable = true; # still need to enable the package
    configDir = ../ags; # sets to /home/kel/.config/ags not 100% sure here :D
  };
  
  home-manager.users.kel.home.file."./.config/ags/config.js".source = ./config.js;

  home-manager.users.kel.home.file.".config/ags/style.css" = {
    text = ''
          label {
          font-family: "Hasklug Nerd Font";
      }

      .workspaces button.focused {
          border-bottom: 3px solid #${config.colorscheme.colors.base05};
      }

      .client-title {
          margin-left: 1em;
          color: #${config.colorscheme.colors.base05};
      }

      .notification image {
          color: #${config.colorscheme.colors.base0F};
          margin-left: 1em;
      }

      .battery progressbar {
          margin: 0 6px;
      }

      .clock {
          margin: 0 6px;
          font-size: 1em;
      }

      progress, highlight {
          background-color: #${config.colorscheme.colors.base05};
          min-height: 8px;
      }
    '';
  };
}
#      .workspaces button,
#      .media {
#          background-color: #${config.colorscheme.colors.base00};
#          color: #${config.colorscheme.colors.base05};
#      }
#
#      .workspaces button:hover,
#      .media:hover {
#          background-color: #${config.colorscheme.colors.base01};
#          color: #${config.colorscheme.colors.base05};
#      }
#      .workspaces button:active,
#      .media:active {
#          background-color: #${config.colorscheme.colors.base04};
#          color: #${config.colorscheme.colors.base05};
#      }

