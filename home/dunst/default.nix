{pkgs, ...}: {
  users.users.kel.packages = with pkgs; [
    dunst
  ];
  imports = [
    #./config.nix
    #./style.nix
    #./configSchema.nix
  ];
}
