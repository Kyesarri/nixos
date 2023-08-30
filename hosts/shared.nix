# /etc/nixos/shared.nix
{ config, pkgs,lib,  ... }:
{

  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose";
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPorts = [ 41641 ]; # tailscale
      allowedTCPPorts = [ 3389 ]; # rdp
    }; # firewall
  }; # networking

  systemd = {
    services = {
      NetworkManager-wait-online.enable = lib.mkForce false; # workaround for a bug with networking when building with flakes
      systemd-networkd-wait-online.enable = lib.mkForce false; # unsure if this affects desktop but leaving here
    }; # services
  }; # systemd

 programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "libsecret";
    };
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
    systemPackages = with pkgs; [
    tailscale
    i2c-tools
    ]; # systemPackages
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
        xsel
        nil
        kdevelop
      ]; # packages
    }; # users.kel
  }; # users

}
# /etc/nixos/shared.nix
