# ./hosts/nix-desktop.nix
{ config, pkgs, lib,  ... }:
{

  imports = [
    ./shared.nix
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
# ./hosts/nix-desktop.nix
