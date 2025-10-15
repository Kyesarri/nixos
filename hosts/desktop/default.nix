{
  nix-colors,
  spaghetti,
  inputs,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    # host specific
    ./boot.nix
    ./hardware.nix
    ./networking.nix
    ./per-device.nix

    # minimal / headless / standard
    ../standard.nix

    # hardware
    ../../hardware
    ../../hardware/audio
    ../../hardware/bluetooth
    # ../../hardware/nvidia
    ../../hardware/rgb

    # packages with configs
    ../../home
    ../../home/bottom
    ../../home/codium
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/git
    ../../home/greetd
    ../../home/keepassxc
    ../../home/gaming
    ../../home/hypr
    ../../home/kde
    ../../home/kitty
    ../../home/ulauncher
    ../../home/virt
    ../../home/waybar
    ../../home/syncthing
    ../../home/gtk
    ../../home/prism
    ../../home/tailscale
    ../../home/zsh
  ];
  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  home-manager.users.${spaghetti.user}.colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # TODO
    };
    hyprpaper.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;
    wifi.backend = "nwm";
  };

  environment.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nix-desktop --show-trace -j 16 && cd ~ && hyprctl reload";
    rebuildboot = "sudo nixos-rebuild --flake ~/nixos#nix-desktop --install-bootloader boot";
    garbage = "sudo nix-collect-garbage && nix-collect-garbage -d";
    s = "kitten ssh";
  };
}
