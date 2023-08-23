# /etc/nixos/shared.nix

{ config, pkgs,lib,  ... }:
{
  networking = {
    firewall = {    
      enable = true;
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect  
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect  
      allowedUDPPorts = [ 41641 ]; # tailscale
    }; # firewall 
  }; # networking 

  programs = {

    dconf.enable = true;
    zsh  = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "fino-time";
#        theme = "jonathan";
        plugins = [
          "sudo"
          "terraform"
          "systemadmin"
          "vi-mode"
          "colorize"
        ]; # plugins
      }; # ohMyZsh
    }; # zsh
  }; # programs

 environment = {

    shells = with pkgs; [ zsh ];
  }; # environment

  users = {

    defaultUserShell = pkgs.zsh;
    users.kel = {
      isNormalUser = true;
      description = "kel";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
        firefox
        kate
        kdeconnect
        nvtop
        git
        tailscale
        trayscale
        qogir-theme
        qogir-kde
        qogir-icon-theme
        asusctl 
        supergfxctl 
        gitui
      ]; # packages
    }; # users.kel
  }; # users

}
# /etc/nixos/shared.nix    
