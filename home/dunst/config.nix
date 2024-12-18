{
  config,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file."/.config/dunst/dunstrc" = {
    text = ''
      [global]
      font="Hack Nerd Font Mono" 10
      frame_color="#${config.colorscheme.palette.base0A}"
      background="#${config.colorscheme.palette.base00}"
      foreground="#${config.colorscheme.palette.base05}"
      highlight="#${config.colorscheme.palette.base05}"
      progress_bar_corner_radius = 10
      height=300
      icon_theme=Qogir-dark
      enable_recursive_icon_lookup = true
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
