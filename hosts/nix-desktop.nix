# /etc/nixos/nix-desktop.nix
{ config, pkgs, lib,  ... }:
{

  imports = [
    ./modules/gaming.nix
    ./modules/smartd.nix
    ./modules/fonts.nix
    ./hosts/shared.nix
    ./hardware/pipewire.nix
    ./hardware/nvidia.nix
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
    systemPackages = with pkgs; [
      i2c-tools
    ]; # systemPackages
  }; # environment

}
# /etc/nixos/nix-desktop.nix
