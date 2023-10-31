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
  
  users.users.kel.packages = with pkgs; [ hyprpaper ];

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];
}
