{
  config,
  pkgs,
  ...
}:
{
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };
  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];
}
