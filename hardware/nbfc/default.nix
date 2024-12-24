{pkgs, ...}: {
  services.thermald.enable = true;
  environment.systemPackages = [pkgs.nbfc_linux];
}
