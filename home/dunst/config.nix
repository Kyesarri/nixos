{
  config,
  inputs,
  outputs,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  home-manager.users.kel.home.file."/.config/dunst/dunstrc" = {
    text = ''
      [global]
      font="Hasklug Nerd Font Regular 9"
      frame_color="#${config.colorscheme.colors.base03}"
      background="#${config.colorscheme.colors.base00}"
      foreground="#${config.colorscheme.colors.base05}"
      highlight="#${config.colorscheme.colors.base0E}"
      progress_bar_corner_radius = 10
      height=300
      icon_theme=Qogir-dark
      enable_recursive_icon_lookup = true
      offset="30x50"
      origin="top-center"
      transparency=10
      width=300
      corner_radius=10
      frame_width=5
      timeout=3

      [signed_on]
      appname = changeVolume
      history_ignore=yes

      [urgency_normal]
      background="#${config.colorscheme.colors.base00}"
      foreground="#${config.colorscheme.colors.base05}"
      highlight="#${config.colorscheme.colors.base0E}"
      timeout=3

    '';
  };
}
