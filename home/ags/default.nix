{
  config,
  inputs,
  outputs,
  lib,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."./.config/ags/config.js".source = ./config.js; # hard to use a .js in nix so symlink works for me
  home-manager.users.kel.home.file.".config/ags/style.css" = {
    # css is much easier, defined here
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

