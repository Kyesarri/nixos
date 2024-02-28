{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [
    chromium
    playwright
  ];

  services.changedetection-io = {
    enable = true;
    webDriverSupport = true;
    playwrightSupport = true;
  };
}
