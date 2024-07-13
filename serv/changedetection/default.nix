{
  pkgs,
  spaghetti,
  ...
}: {
  users.users.${spaghetti.user}.packages = [
    # pkgs.chromium # not sure if this is required, hate chromium
    pkgs.playwright
    pkgs.selenium-server-standalone
  ];

  services.changedetection-io = {
    enable = true;
    # webDriverSupport = true;
    playwrightSupport = true;
  };
}
# lots of options to create here :)

