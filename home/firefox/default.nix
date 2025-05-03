{
  spaghetti,
  pkgs,
  ...
}: {
  environment.sessionVariables = {MOZ_ENABLE_WAYLAND = "1";};

  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/librewolf.conf" = {
    text = ''
      # keybind
      bind = $mainMod, F, exec, librewolf
      # change border colour
      windowrulev2 = bordercolor $ce, initialClass:^(librewolf)$
    '';
  };

  programs.firefox = {
    enable = true;

    package = pkgs.librewolf;

    policies = {
      DisableTelemetry = true;
      DisableFirefoxStudies = true;

      Preferences = {
        "cookiebanners.service.mode.privateBrowsing" = 2;
        "cookiebanners.service.mode" = 2;
        "privacy.donottrackheader.enabled" = true;

        # cant have darkmode default theme in browser, causes white loading pages eww...
        # "privacy.fingerprintingProtection" = true;
        # "privacy.resistFingerprinting" = true;
        # "privacy.trackingprotection.fingerprinting.enabled" = true;

        "privacy.trackingprotection.emailtracking.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
      };
    };
  };
}
