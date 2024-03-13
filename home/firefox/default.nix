{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  home-manager.users.${spaghetti.user}.home.file.".config/hypr/per-app/firefox.conf" = {
    text = ''
      bind = $mainMod, F, exec, firefox
      bind = $mainMod, W, exec, firefox -p work --name work
      windowrulev2 = bordercolor $ce, initialClass:^(work)$
      windowrulev2 = noshadow, nodim, initialClass:^(work)$
      windowrulev2=float, class:firefox.*$, title:Extension: (Bitwarden - Free Password Manager) - Bitwarden — Mozilla Firefox
    '';
  };

  environment.sessionVariables = rec {MOZ_ENABLE_WAYLAND = "1";}; # is this required anymore?

  users.users.${spaghetti.user}.packages = with pkgs; [firefox]; # is this required? probs
  programs.firefox = {
    enable = true;
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
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
/*
flake.nix
    firefox-gnome-theme = {
      url = "github:rafaelmardojai/firefox-gnome-theme";
      flake = false;
    };

firefox.nix

  home-manager.users.${spaghetti.user}.home = {

  sessionVariables.BROWSER = "firefox";

  file."firefox-gnome-theme" = {
    target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
    source = inputs.firefox-gnome-theme;
  };
};
*/

