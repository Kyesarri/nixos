# ./hosts/nix-desktop.nix
{
  config,
  pkgs,
  lib,
  inputs,
  outputs,
  nix-colors,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./shared.nix
    ./desktop-hw.nix

    ../configuration.nix

    ../modules/gaming.nix
    ../modules/fonts.nix

    ../hardware/pipewire.nix
    ../hardware/openrgb.nix
    ../hardware/nvidia.nix

    ../home/home.nix
    ../home/hyprpaper.nix
    ../home/hyprland.nix
    ../home/waybar.nix
    ../home/kitty.nix
    ../home/wofi
    ../home/dunst
    ../home/lite-xl
    ../home/hypr
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # uses base16 colours see here: https://github.com/tinted-theming/base16-schemes

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-desktop";
  networking.wireless.iwd.enable = true;

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  environment = {
    systemPackages = with pkgs; [i2c-tools pciutils];
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
    };
  };
}
# ./hosts/nix-desktop.nix

