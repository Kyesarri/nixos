# ./hosts/shared.nix

# all the home-manager items can be moved to another nix "soon"
{ config, pkgs,lib,  ... }:
{
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
      checkReversePath = "loose"; # fixes some connection issues with tailscale, could not find local network without this option
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPorts = [ 41641 ]; # tailscale
      allowedTCPPorts = [ 3389 ]; # rdp
    };
  };

  services = {
    tailscale = {
      useRoutingFeatures = "client";
    };
  };

  systemd = {
    services = {
      NetworkManager-wait-online.enable = false; # workaround for a bug with networking when building with flakes
      systemd-networkd-wait-online.enable = false; # unsure if this affects desktop but leaving here
    };
  };

  programs = {
    partition-manager.enable = true;
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
        ];
      };
      syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "line" ];
      syntaxHighlighting.patterns = { };
      syntaxHighlighting.styles = { "globbing" = "none"; };
      promptInit = "info='n os wm sh n' fet.sh";
    };
  };

  environment = {
    sessionVariables = { GTK_THEME = "Qogir-Dark"; }; # sets default gtk theme
    shells = with pkgs; [ zsh ]; # default shell to zsh
    systemPackages = with pkgs; [
      tailscale
      i2c-tools
      _2bwm # need to work on this further, no docs anywhere, using config from https://git.peppe.rs/config/nixos/tree/home.nix
      ];

    plasma5 = {
      excludePackages = with pkgs.libsForQt5; [  ];
    };

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
        kdevelop # will this work outside of kde? probably should
        remmina # rdp client
        fet-sh
        isoimagewriter
        libsForQt5.lightly
        ];
    };
  };

}
# ./hosts/shared.nix
