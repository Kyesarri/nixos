{
  config,
  inputs,
  outputs,
  pkgs,
  nix-colors,
  ...
}: 
{
  home-manager.users.kel.programs.kitty = {
    enable = true;
    settings = {
    
      active_tab_foreground = "#${config.colorScheme.colors.base05}";
      active_tab_background = "#${config.colorScheme.colors.base00}";
      
      foreground = "#${config.colorScheme.colors.base05}";
      background = "#${config.colorScheme.colors.base00}";
      url_color = "#${config.colorScheme.colors.base0E}";
      
      repaint_delay = "12";
      sync_to_monitor = "yes";
      background_opacity = "1.0";
      background_blur = "1";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      font_family = "Hasklug Nerd Font Regular";
      bold_font = "Hasklug Nerd Font ExtraBold";
      italic_font = "Hasklug Nerd Font Italic";
      bold_italic_font = "Hasklug Nerd Font ExtraBold Italic";
      font_size = "10.0";
      cursor_shape = "beam";
      cursor_beam_thickness = "2.0";
      cursor_blink_interval = "0.5";
      strip_trailing_spaces = "always";
    };
  };
}
