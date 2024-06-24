{
  pkgs,
  inputs,
  nix-colors,
  spaghetti,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default

    ./per-device.nix
    ./hardware.nix
    ./boot.nix

    ../minimal.nix

    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/wifi
    ../../hardware/audio

    ../../home
    ../../home/bottom
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/foot
    ../../home/git
    ../../home/gtk
    ../../home/hypr
    ../../home/keepassxc
    ../../home/lite-xl
    # ../../home/waybar
    ../../home/ulauncher
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

  environment = {
    systemPackages = with pkgs; [pciutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-notebook --show-trace";
  };
}
