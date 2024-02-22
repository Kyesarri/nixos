{
  config,
  inputs,
  outputs,
  pkgs,
  nix-colors,
  user,
  ...
}: {
  home-manager.users.${user} = {
    programs.kitty = {
      enable = true;
      settings = {
        active_tab_foreground = "#${config.colorScheme.palette.base05}";
        active_tab_background = "#${config.colorScheme.palette.base03}";

        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";
        url_color = "#${config.colorScheme.palette.base0E}";

        #test terminal8, hot, love it
        color0 = "#${config.colorScheme.palette.base00}";
        color1 = "#${config.colorScheme.palette.base08}";
        color2 = "#${config.colorScheme.palette.base0B}";
        color3 = "#${config.colorScheme.palette.base0A}";
        color4 = "#${config.colorScheme.palette.base0D}";
        color5 = "#${config.colorScheme.palette.base0E}";
        color6 = "#${config.colorScheme.palette.base0C}";
        color7 = "#${config.colorScheme.palette.base07}";

        repaint_delay = "12";
        sync_to_monitor = "yes";
        background_opacity = "1.0";
        background_blur = "1";
        tab_bar_style = "powerline";
        tab_powerline_style = "round";
        font_family = "Hack Nerd Font Mono";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";
        font_size = "10.0";
        cursor_shape = "beam";
        cursor_beam_thickness = "2.0";
        cursor_blink_interval = "0.5";
        strip_trailing_spaces = "always";
        update_check_interval = "0"; # dont want to check for updates, rather update via flakes
      };
    };
    home.file.".config/hypr/per-app/kitty.conf" = {
      text = ''
        windowrulev2 = opacity 0.8 0.8, class:^(kitty)$
        windowrulev2 = size 700 300, class:^(kitty)$
        windowrulev2 = center, class:^(kitty)$
        # TODO make above a single line :)
        bind = $mainMod, Q, exec, kitty
        bind = control, escape, exec, kitty -e btm
        windowrule = float, title:zsh
      '';
    };
  };
}
