{
  pkgs,
  inputs,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    # per-device configs
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./per-device.nix

    # minimal / headless / standard
    ../standard.nix

    # hardware
    ../../hardware/audio
    ../../hardware/bluetooth
    ../../hardware/nvidia
    ../../hardware/rgb
    ../../hardware/wifi

    # packages with configs
    ../../home
    ../../home/ags
    ../../home/bottom
    ../../home/codium
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/git
    ../../home/gaming
    ../../home/hypr
    ../../home/kde
    ../../home/kitty
    ../../home/ulauncher
    ../../home/virt
    ../../home/gtk
    ../../home/syncthing
    ../../home/tailscale
    ../../home/zsh
  ];

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
    hyprpaper.enable = true;
    ags.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
    wifi.backend = "nwm";
  };

  services = {
    xserver.enable = false;
  };

  environment = {
    systemPackages = with pkgs; [
      pciutils
      tailscale # lets users control tailscale
    ];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-desktop --show-trace -j 16 && cd ~ && hyprctl reload && ./ags.sh";
  };
}
