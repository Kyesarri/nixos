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
    home.username = "kel";
    programs.home-manager.enable = true;

home.file.".config/qtile".source = ./desktop/configs/qtile;
    home.stateVersion = "23.05";
    home.packages = with pkgs; [ libsForQt5.kcolorpicker ];

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
      settings =
      [{
      layer = "top";
	  position = "top";
	  height = 24;
	  modules-left = [""];
	  modules-center = [""];
	  modules-right = ["custom/stopwatch" "cpu" "memory" "network" "pulseaudio" "battery" "clock" "tray"];

	  "network" = {
	    format-wifi = "  {essid} ({signalStrength}%)";
	    format-ethernet = " {ifname}: {ipaddr}/{cidr}";
	    format-disconnected = "Disconnected ⚠";
	  };

	  "memory" = {
	    interval = 5;
	    format = "  {}%";
	    states = {
	      warning = 70;
	      critical = 90;
	    };
	  };

	  "pulseaudio" = {
	    format = "{icon} {volume}%";
	    format-bluetooth = "{icon} {volume}%";
	    format-muted = " 0%";
	    format-icons = {
	      "headphones" = " ";
	      "handsfree" = " ";
	      "headset" = " ";
	      "phone" = " ";
	      "portable" = " ";
	      "car" = " ";
	      "default" = [" " " "];
	    };
	  };

	  "battery" = {
	    bat = "BAT0";
	    states = {
	      "warning" = 30;
	      "critical" = 15;
	    };
	    format = "{icon}  {capacity}%";
	    format-icons = [" " " " " " " " " "];
	  };
	  "clock" = {
	    format = "{:%a %d %b %H:%M}";
	  };
	}];
      };
  };
}


#    programs.waybar =
#    {
#    enable = true;
#    settings =
#    {
#      mainBar =
#      {
#        layer = "top";
#        position = "top";
#        height = 30;
#        output = [
#          "eDP-1"
#          "HDMI-A-1"
#        ];
#        modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
#        modules-center = [ "sway/window" "custom/hello-from-waybar" ];
#        modules-right = [ "mpd" "custom/mymodule#with-css-id" "temperature" ];
#
#        "sway/workspaces" =
#        {
#          disable-scroll = true;
#          all-outputs = true;
#        };
#        "custom/hello-from-waybar" =
#        {
#          format = "hello {}";
#          max-length = 40;
#          interval = "once";
#          exec = pkgs.writeShellScript "hello-from-waybar" ''
#          echo "from within waybar"
#        '';
#        };
#      };
#    };
#  };
#};
#}
# ./home/home.nix
