{pkgs, ...}: {
  services.netbird.enable = true; # for netbird service & cli
  environment.systemPackages = [pkgs.netbird-ui]; # for gui
}
