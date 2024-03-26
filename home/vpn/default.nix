{
  config,
  pkgs,
  spaghetti,
  ...
}: {
  services.netbird.enable = true; # for netbird service & CLI
  environment.systemPackages = [pkgs.netbird-ui]; # for GUI
}
