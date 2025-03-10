{
  # pkgs,
  config,
  spaghetti,
  ...
}: {
  environment.sessionVariables = {MOZ_ENABLE_WAYLAND = "1";};

  home-manager.users.${spaghetti.user} = {
    #
    home.file.".config/hypr/per-app/firefox.conf" = {
      text = ''
        bind = $mainMod, F, exec, schizofox
        # bind = $mainMod, W, exec, firefox -p work --name work
        windowrulev2 = bordercolor $ce, initialClass:^(firefox)$
        # windowrulev2 = noshadow, nodim, initialClass:^(work)$
      '';
    };

    programs.schizofox = {
      enable = true;
      search = {
        removeEngines = ["Google" "Bing" "Amazon.com" "eBay" "Twitter" "Wikipedia"];
        searxUrl = "https://searx.be";
      };
      misc = {
        startPageURL = "https://homer.home/";
      };
      extensions = {
        simplefox.enable = false;
        enableDefaultExtensions = true;
        darkreader.enable = true;
      };
      security = {
        userAgent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko)";
        sandbox.enable = false; # workaround for keepass addon in schizofox #TODO not perfect
      };
      theme = {
        colors = {
          background-darker = "${config.colorScheme.palette.base00}"; # bg1
          background = "${config.colorScheme.palette.base02}"; # bg2
          foreground = "${config.colorScheme.palette.base05}"; # text
          primary = "${config.colorScheme.palette.base07}"; # accent1
          border = "${config.colorScheme.palette.base0E}"; # accent2
        };
        font = "IBM Plex Sans";
      };
    };
  };
}
