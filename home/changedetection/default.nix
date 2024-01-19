{
  pkgs,
  user,
  ...
}: {
  users.users.${user}.packages = [
    chromium
    playwright
  ];

  services.changedetection-io = {
    enable = true;
    webDriverSupport = true;
    playwrightSupport = true;
  };
}
