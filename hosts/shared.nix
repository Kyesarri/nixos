# ./hosts/shared.nix

# all the home-manager items can be moved to another nix "soon"
{ config, pkgs,lib,  ... }:
{
  networking =
  {
    networkmanager.enable = true;
    firewall =
    {
      enable = true;
      checkReversePath = "loose"; # fixes some connection issues with tailscale, could not find local network without this option
      allowedTCPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPortRanges = [ { from = 1714; to = 1764; } ]; # kdeconnect
      allowedUDPPorts = [ 41641 ]; # tailscale
      allowedTCPPorts = [ 3389 ]; # rdp
    };
  };

  services.tailscale.useRoutingFeatures = "client"; # set as client for tailscale
  systemd.services.NetworkManager-wait-online.enable = false; # workaround for a bug with networking when building with flakes
  systemd.services.systemd-networkd-wait-online.enable = false; # unsure if these affect desktop but leaving here

  programs =
  {
    dconf.enable = true;

    git =
    {
      enable = true;
      package = pkgs.gitFull;
    };

    zsh  =
    {
      enable = true;
      enableCompletion = true;
      autosuggestions.enable = true;
      syntaxHighlighting.highlighters = [ "main" "brackets" "pattern" "cursor" "line" ];
      syntaxHighlighting.patterns = { };
      syntaxHighlighting.styles = { "globbing" = "none"; };
      promptInit = "info='n host cpu os wm sh n' fet.sh";
      ohMyZsh =
      {
        enable = true;
        theme = "fino-time";
        plugins = [ "sudo" "terraform" "systemadmin" "vi-mode" "colorize" ];
      };
    };
  };

  environment =
  {
    sessionVariables = rec
    {
      MOZ_ENABLE_WAYLAND = "1";
      GTK_THEME = "Qogir-Dark"; # sets default gtk theme to dark
      GTK_ICON_THEME = "Qogir-Dark"; # dont know if this works, does not throw an error but no icons are appplied :)
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/dots/config"; # moves config to home/share rather than home/.config
      XDG_DATA_HOME   = "$HOME/dots/share"; # will move to /home/nixos soon
      XDG_STATE_HOME  = "$HOME/dots/state";
      NIXOS_OZONE_WL = "1"; # fixes electron apps in wayland
    };
    shells = with pkgs; [ zsh ]; # default shell to zsh
    systemPackages = with pkgs;
    [
      lshw # list hardware
      usbutils # usb thing
      busybox # nice-to-have
      curl
      wget
      libsecret
    ];
  };

  users =
  {
    defaultUserShell = pkgs.zsh;
    users.kel =
    {
      isNormalUser = true;
      description = "kel";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs;
      [
        firefox # the lad
        kdeconnect # phone sync
        nvtop # watching gpu usage
        tailscale # mah boi
        tailscale-systray # need to autostart this, requires root to change settings
        qogir-theme # used to set dark theme for gtk applications
        xsel # nixos language lib, not sure if needed for kdev or builder
        remmina # rdp client
        fet-sh # minimalistic fetch script, TODO: look into how this is packaged as a nixos module
        hyprpaper # wallpaper for wayland
        gvfs # gnome file system thing, unsure if required now
        gnome-builder # ide / basic boi
        pamixer # cli pulse audio mixer
        pavucontrol # audio control gui
        brightnessctl # brightness control, used in waybar config
        qogir-icon-theme # icons, not sure how to use :)
        qogir-theme # theme
        wl-color-picker # wayland colour picker
        cinnamon.nemo-with-extensions # file manager
        bottom # hot CLI task manager
        gnome.seahorse # key management
        networkmanagerapplet # adds gui for network
        blueberry # bluetooth gui
     ];
    };
  };

}
# ./hosts/shared.nix
