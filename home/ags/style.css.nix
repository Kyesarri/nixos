{
  inputs,
  outputs,
  pkgs,
  user,
  config,
  ...
}: {
  ### base0a is normally orange (other themes) its blue and the main highlight i use in tokyo-night-dark theme
  ### need to work on themes overall to get a more generalised theme applied
  ### that would look better across multiple base-16 themes

  home-manager.users.${user} = {
    home.file.".config/ags/style.css" = {
      text = ''
        window.bar {
            background-color: @theme_bg_color;
            color: @theme_fg_color;
        }

        button {
            min-width: 0;
            padding-top: 0;
            padding-bottom: 0;
            background-color: transparent;
        }

        button:active {
            background-color: @theme_selected_bg_color;
        }

        button:hover {
            border-bottom: 3px solid @theme_fg_color;
        }

        label {
            font-weight: bold;
        }

        .workspaces button.focused {
            border-bottom: 3px solid @theme_selected_bg_color;
        }

        .client-title {
            color: @theme_selected_bg_color;
        }

        .notification {
            color: yellow;
        }

        progress,
        highlight {
            min-height: 8px;
        }
      '';
    };
  };
}
