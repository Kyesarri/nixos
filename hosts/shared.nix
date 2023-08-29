# /etc/nixos/shared.nix

{ config, pkgs,lib,  ... }:

{
  networking = {
    firewall = {
      enable = true;
      checkReversePath = "loose";  
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect  
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect  
      allowedUDPPorts = [ 41641 ]; # tailscale
      allowedTCPPorts = [ 3389 ]; # rdp
    }; # firewall 
  }; # networking 

 programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "libsecret";
    }; # git - not sure if I need to remove this now
    dconf.enable = true;
    zsh  = {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      ohMyZsh = {
        enable = true;
        theme = "fino-time";
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
    sessionVariables = { GTK_THEME = "Qogir-Dark"; };
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
        tailscale
        tailscale-systray
        qogir-theme
        qogir-kde
        qogir-icon-theme
        busybox
        xsel
        nil
        kdevelop
      ]; # packages
    }; # users.kel
  }; # users

}
# /etc/nixos/shared.nix    
