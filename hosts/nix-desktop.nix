# ./hosts/nix-desktop.nix
{ config, pkgs, lib,  ... }:
{

  imports =
  [
    ./shared.nix
    ../home/home.nix
    ../hardware/openrgb.nix
    ../configuration.nix
    ../modules/gaming.nix
    ../modules/fonts.nix
    ../hardware/pipewire.nix
    ../hardware/nvidia.nix
    ./desktop-hw.nix
  ];

  hardware.bluetooth.enable = true;
  networking.hostName = "nix-desktop";

  services.xserver =
  {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };

  environment = {
    systemPackages = with pkgs; [ i2c-tools pciutils ];
    shellAliases =
    {
      rebuild   = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
    };
  };
}
# ./hosts/nix-desktop.nix
