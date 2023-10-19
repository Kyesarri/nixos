{
  pkgs,
  config,
  lib,
  ...
}: {
  users.users.kel.packages = with pkgs; [
    swaynotificationcenter
  ];
  imports = [
    ./config.nix
    ./style.nix
    ./configSchema.nix
  ];
}
