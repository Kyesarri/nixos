{
  lib,
  pkgs,
  config,
  spaghetti,
  inputs,
  ...
}:
with lib; let
  cfg = config.gnocchi.hypr; # shorthand some lines
in {
  # wayland.windowManager.hyprland.extraConfig = lib.mkAfter ''
  # libmkafter looks vvv interesting
  options.gnocchi = {
    hypr = {
      enable = mkEnableOption "enable hyprland"; # will be gnocchi.hypr.enable = true; in host.nix
      hyprpaper.enable = mkEnableOption "enable hyprpaper with config, can do type of, and set source dir?";
      animations.enable = mkEnableOption "enable hypr animations";
    };
  };

  config = mkMerge [
    (mkIf (cfg.enable) {
      #
      programs.hyprland.enable = true; # enable hyprland, needed w below?
      home-manager.users.${spaghetti.user} = {
        wayland.windowManager.hyprland = {
          enable = true;
          systemd.enable = true;
          # plugins = [hy3.packages.x86_64-linux.hy3];
          extraConfig = ''${builtins.readFile ./config/hyprland.conf}'';
        };
        home.file.".config/hypr/colours.conf" = {
          text = ''
            # add nix-colors below, sourced in hyprland.conf
            $c0 = rgba(${config.colorscheme.palette.base00}FF)
            $c1 = rgba(${config.colorscheme.palette.base01}FF)
            $c2 = rgba(${config.colorscheme.palette.base02}FF)
            $c3 = rgba(${config.colorscheme.palette.base03}FF)
            $c4 = rgba(${config.colorscheme.palette.base04}FF)
            $c5 = rgba(${config.colorscheme.palette.base05}FF)
            $c6 = rgba(${config.colorscheme.palette.base06}FF)
            $c7 = rgba(${config.colorscheme.palette.base07}FF)
            $c8 = rgba(${config.colorscheme.palette.base08}FF)
            $c9 = rgba(${config.colorscheme.palette.base09}FF)
            $ca = rgba(${config.colorscheme.palette.base0A}FF)
            $cb = rgba(${config.colorscheme.palette.base0B}FF)
            $cc = rgba(${config.colorscheme.palette.base0C}FF)
            $cd = rgba(${config.colorscheme.palette.base0D}FF)
            $ce = rgba(${config.colorscheme.palette.base0E}FF)
            $cf = rgba(${config.colorscheme.palette.base0F}FF)
          '';
        };
        #
        # break for humans
        #
      };
    })

    #
    # break for humans
    # make if hypr + hyprpaper are enabled
    #
    (mkIf (cfg.enable || cfg.hyprpaper.enable) {
      users.users.${spaghetti.user}.packages = [pkgs.hyprpaper];
      home-manager.users.${spaghetti.user} = {
        home.file.".config/hypr/hyprpaper.conf" = {
          text = ''
            preload = /home/${spaghetti.user}/wallpapers/1.jpg
            preload = /home/${spaghetti.user}/wallpapers/2.jpg
            preload = /home/${spaghetti.user}/wallpapers/3.jpg
            preload = /home/${spaghetti.user}/wallpapers/4.jpg
            preload = /home/${spaghetti.user}/wallpapers/5.png
            # ^ images must be preloaded to display
            wallpaper = , /home/${spaghetti.user}/wallpapers/5.png
            # ^ any display, directory/image.extension
            splash = false
          '';
        };
        home.file.".config/hypr/per-app/hyprpaper.conf" = {
          text = ''
            exec-once = sleep 2 && hyprpaper
            # launch hyprpaper in per-app
          '';
        };
      };
    })
  ];
}
