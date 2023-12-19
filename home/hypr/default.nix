{
  config,
  pkgs,
  inputs,
  user,
  ...
}: {
  programs.hyprland = {
    enable = true;
    enableNvidiaPatches = true;
  };

  users.users.${user}.packages = with pkgs; [hyprpaper];

  imports = [
    ./hyprland.nix
    ./hyprpaper.nix
  ];
}
