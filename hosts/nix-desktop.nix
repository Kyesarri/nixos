# ./hosts/nix-desktop.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    inputs.nix-colors.homeManagerModules.default
    ./shared.nix
    ../home/home.nix
    ../home/hyprpaper.nix
    ../home/hyprland.nix
    ../home/waybar.nix
    ../home/kitty.nix
    ../hardware/openrgb.nix
    ../configuration.nix
    ../modules/gaming.nix
    ../modules/fonts.nix
    ../hardware/pipewire.nix
    ../hardware/nvidia.nix
    ./desktop-hw.nix
  ];

  colorScheme = inputs.nix-colors.colorSchemes.tokyo-night-dark; # uses base16 colours see here: https://github.com/tinted-theming/base16-schemes

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-desktop";

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

