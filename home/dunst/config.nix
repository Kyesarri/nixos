{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file."/.config/dunst/dunstrc" = {
    text = ''
      [global]
      font="Hack Nerd Font Mono" 10
      frame_color="#${config.colorscheme.palette.base0E}"
      background="#${config.colorscheme.palette.base00}"
      foreground="#${config.colorscheme.palette.base05}"
      highlight="#${config.colorscheme.palette.base0E}"

      progress_bar_corner_radius = 6
      progress_bar_height = 6
      progress_bar_frame_width = 2
      progress_bar_corners = all

      height=300

      follow = mouse

      icon_theme=Zafiro-icons-Dark
      enable_recursive_icon_lookup = true
      min_icon_size = 16
      max_icon_size = 16
      icon_position = top

      ellipsize = middle

      alignment = center
      offset="30x50"
      origin="top-center"
      transparency=10
      width=300
      corner_radius=10
      frame_width=3
      timeout=3

      [urgency_normal]
      background="#${config.colorscheme.palette.base00}"
      foreground="#${config.colorscheme.palette.base05}"
      highlight="#${config.colorscheme.palette.base03}"
      timeout=3

      [urgency_critical]
      background="#${config.colorscheme.palette.base00}"
      foreground="#${config.colorscheme.palette.base0F}"
      frame_color="#${config.colorscheme.palette.base0F}"
      highlight="#${config.colorscheme.palette.base0A}"
      timeout=5


    '';
  };
}
