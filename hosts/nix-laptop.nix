# /etc/nixos/nix-laptop.nix

{ config, pkgs,lib,  ... }:
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
    systemPackages = with pkgs; [
      asusctl
      supergfxctl 
    ]; # systemPackages
  }; # environment
  environment = {
    sessionVariables = { GTK_THEME = "Qogir-Dark"; }; 
    }; # enviornment
}
# /etc/nixos/nix-laptop.nix
