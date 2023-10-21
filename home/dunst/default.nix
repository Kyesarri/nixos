{pkgs, ...}: {
  # users.users.kel.packages = with pkgs; [
  # dunst
  # ];
  home-manager.users.kel.services.dunst.enable = true;

  imports = [
    ./config.nix
  ];
}
