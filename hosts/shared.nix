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

  services.tailscale.useRoutingFeatures = "client"; # set as client, have a exit node running on vm under proxmox
  systemd.services.NetworkManager-wait-online.enable = false; # workaround for a bug with networking when building with flakes
  systemd.services.systemd-networkd-wait-online.enable = false; # unsure if this affects desktop but leaving here

  programs =
  {
    dconf.enable = true;

    git =
    {
      enable = true;
      package = pkgs.gitFull;
      config.credential.helper = "libsecret";
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
      GTK_THEME = "Matcha-dark-azul"; # sets default gtk theme to dark
      GTK_ICON_THEME = "Matcha-dark-azul";
      XDG_CACHE_HOME  = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/dots/config"; # moves config to home/share rather than home/.config
      XDG_DATA_HOME   = "$HOME/dots/share";
      XDG_STATE_HOME  = "$HOME/dots/state";
    };
    shells = with pkgs; [ zsh ]; # default shell to zsh
    systemPackages = with pkgs;
    [
      i2c-tools
      lshw
      usbutils
      busybox # nice-to-have
      curl
      wget
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
        xfce.xfce4-taskmanager # taskmanager, nice
        gnome-builder # ide / basic boi
        gnome.nautilus # file manager
        pamixer # cli pulse audio mixer
        pavucontrol # audio control gui
        brightnessctl # brightness control, used in waybar config
        matcha-gtk-theme # gtk theme
        wl-color-picker # wayland colour picker
     ];
    };
  };

}
# ./hosts/shared.nix
