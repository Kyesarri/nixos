# ./home/home.nix
# TODO move hyprland / wofi / kitty / mako / waybar / hyprpaper to their own nix
{
home-manager.useUserPackages = true;    # install packages to /etc/profiles instead of ~/.nix-profile
home-manager.useGlobalPkgs = true;      # this saves an extra Nixpkgs evaluation, adds consistency,
					# and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.
  home-manager.users.kel =
  { pkgs, config, inputs, outputs, ... }:
  {
    imports =
    [
      inputs.nix-colors.homeManagerModules.default
    ];

    colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # uses base16 colours see here: https://github.com/tinted-theming/base16-schemes
								   # TODO lots to refactor here, dont like the import / colour scheme


    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    programs.home-manager.enable = true;
    home.stateVersion = "23.05";
    services.mako.enable = true; # TODO notification service, needs more work, just using stock config currently
    home.packages = with pkgs; [  ];
    programs.git =
    {
      enable = true;
      extraConfig =
      {
        credential.helper = "libsecret";
      };
    };
    programs.wofi = # TODO wofi needs more options defined and configured, colours and appearance
    {
      enable = true;
      settings =
      {
        width=750;
        height=400;
        always_parse_args=true;
        show_all=false;
        print_command=true;
        insensitive=true;
      };
    };

    programs.kitty =
    {
      enable = true;
      settings =
      {
        active_tab_foreground = "#${config.colorScheme.colors.base05}"; # colours from color-nix
	active_tab_background = "#${config.colorScheme.colors.base00}";
	foreground = "#${config.colorScheme.colors.base05}";
	background = "#${config.colorScheme.colors.base00}";
	background_opacity = "1.0";
	background_blur = "1";
	tab_bar_style = "powerline";
	tab_powerline_style = "round";
	font_family = "JetBrainsMonoNL NF Regular";
	bold_font = "JetBrainsMonoNL NF ExtraBold";
	italic_font = "JetBrainsMonoNL NF Italic";
	bold_italic_font = "JetBrainsMonoNL NF ExtraBold Italic";
	font_size = "10.0";
      };
    };
    programs.waybar =
    {
      enable = true;
      package = (pkgs.waybar.override (oldAttrs: { pulseSupport = true;} )); # might want to declare waybar as hyprland is
    };
  };
}
# ./home/home.nix
