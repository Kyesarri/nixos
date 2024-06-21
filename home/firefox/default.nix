{
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user} = {
    # add hyprland bindings for firefox
    # + window rules
    home.file.".config/hypr/per-app/firefox.conf" = {
      text = ''
        bind = $mainMod, F, exec, firefox
        bind = $mainMod, W, exec, firefox -p work --name work
        windowrulev2 = bordercolor $ce, initialClass:^(work)$
        windowrulev2 = noshadow, nodim, initialClass:^(work)$
      '';
    };
  };

  environment.sessionVariables = {MOZ_ENABLE_WAYLAND = "1";}; # is this required anymore?

  programs.firefox = {
    enable = true;
    # using bin to speed up flake updates
    package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
      extraPolicies = {
        # turn off / on some default annoyances
        CaptivePortal = false;
        DisableFirefoxStudies = true;
        DisablePocket = true;
        DisableTelemetry = true;
        DisableFirefoxAccounts = false;
        NoDefaultBookmarks = true;
        OfferToSaveLogins = false;
        OfferToSaveLoginsDefault = false;
        PasswordManagerEnabled = false;
        FirefoxHome = {
          Search = true;
          Pocket = false;
          Snippets = false;
          TopSites = false;
          Highlights = false;
        };
        UserMessaging = {
          ExtensionRecommendations = false;
          SkipOnboarding = true;
        };
      };
    };
  };
}
