{
  pkgs,
  inputs,
  spaghetti,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./per-device.nix
    ./hardware.nix
    ./boot.nix

    ../minimal.nix

    ../../hardware
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/audio

    ../../home
    ../../home/ags
    ../../home/bottom
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/git
    ../../home/greetd
    ../../home/gtk
    ../../home/hypr
    ../../home/kde
    ../../home/kitty
    ../../home/keepassxc
    ../../home/lite-xl
    ../../home/ulauncher
    ../../home/prism
    ../../home/zsh
  ];

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet - will need refactor
    };
    hyprpaper.enable = true;
    ags.enable = true;
    gscreenshot.enable = true;
    freetube.enable = true;

    wifi.backend = "nwm";
  };

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking.hostName = "nix-notebook";

  services.xserver.enable = true;

  security.polkit.adminIdentities = []; # for passwordless config - will ask for root credentials vs user

  environment = {
    systemPackages = with pkgs; [pciutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-notebook --show-trace";
  };
}
