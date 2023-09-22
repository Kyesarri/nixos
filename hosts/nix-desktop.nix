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
  ];

  hardware = {
    bluetooth.enable = true;
  }; # hardware

  networking = {
    hostName = "nix-desktop";
  }; # networking

  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    }; # xserver
  }; # services

  environment = {
    systemPackages = with pkgs; [ i2c-tools ];
    shellAliases =
    {
      rebuild   = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-desktop --show-trace";
    };
  };
}
# ./hosts/nix-desktop.nix
