# ./hosts/nix-laptop.nix
{ config, pkgs, lib,  ... }:
{

  imports = [
    ./shared.nix
  ];

  hardware = {
    bluetooth.enable = true;
  }; # hardware

  networking = {
    hostName = "nix-laptop";
  };

  systemd = {
    services = {
      supergfxd.path = [ pkgs.pciutils ]; # gpu switching
    }; # services
  }; # systemd

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    }; # asusd
    supergfxd.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "nvidia" ];
    }; # xserver
  }; # services

  users = {
    users.kel = {
      packages = with pkgs; [
      ]; # packages
    }; # users.kel
  }; # users

  environment = {
    shellAliases = {
      rebuild   = "sudo nixos-rebuild switch --flake /home/kel/nixos#nix-laptop --show-trace";
    };
    systemPackages = with pkgs; [
#      asusctl
#      supergfxctl
    ]; # systemPackages
  }; # environment

}
# ./hosts/nix-laptop.nix
