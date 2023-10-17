{
  config,
  inputs,
  outputs,
  pkgs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.programs.kitty = {
    enable = true;
    settings = {
      active_tab_foreground = "#${config.colorScheme.colors.base05}";
      active_tab_background = "#${config.colorScheme.colors.base00}";
      foreground = "#${config.colorScheme.colors.base05}";
      background = "#${config.colorScheme.colors.base00}";
      background_opacity = "1.0";
      background_blur = "1";
      tab_bar_style = "powerline";
      tab_powerline_style = "round";
      font_family = "Hasklug Nerd Font Regular";
      bold_font = "Hasklug Nerd Font ExtraBold";
      italic_font = "Hasklug Nerd Font Italic";
      bold_italic_font = "Hasklug Nerd Font ExtraBold Italic";
      font_size = "10.0";
    };
  };
}
