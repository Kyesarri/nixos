# ./home/home.nix
let
  # define colours to be used in home packages
  colour = import ../modules/colour.nix;
in
{
  home-manager.useUserPackages = true;    # install packages to /etc/profiles instead of ~/.nix-profile
  home-manager.useGlobalPkgs = true;      # this saves an extra Nixpkgs evaluation, adds consistency,
					  # and removes the dependency on NIX_PATH, which is otherwise used for importing Nixpkgs.

  home-manager.users.kel =
  { pkgs, config, ... }:
  {
    xdg.enable = true;
    home.username = "kel";
    home.homeDirectory = "/home/kel";
    programs.home-manager.enable = true;
    home.stateVersion = "23.05";
    services.mako.enable = true;
    home.packages = with pkgs; [  ];
    programs.wofi.enable = true;
    programs.kitty =
    {
      enable = true;

      settings =
      {
        active_tab_foreground = "#${colour.accent1}";
	active_tab_background = "#${colour.background}";
	foreground = "#${colour.text}";
	background = "#${colour.background}";
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
      package = (pkgs.waybar.override (oldAttrs: { pulseSupport = true;} ));

};
  };
}
# ./home/home.nix