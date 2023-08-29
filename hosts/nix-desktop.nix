# /etc/nixos/nix-desktop.nix
# specific configuration for 13900kf / 3070 / z790i edge wifi
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
    nvidia = {
      modesetting.enable = true; # required for native resolution in TTY
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    }; # nvidia 
  }; # hardware 

  networking = {
    hostName = "nix-desktop"; 
    networkmanager.enable = true;
    firewall = {    
      enable = true;
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; #kdeconnect  
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; #kdeconnect  
    }; # firewall
  }; #networking

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
