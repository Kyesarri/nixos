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
    ../../home/bottom
    ../../home/copyq
    ../../home/dunst
    ../../home/firefox
    ../../home/git
    ../../home/greetd
    ../../home/gtk
    ../../home/hypr
    ../../home/kitty
    ../../home/keepassxc
    ../../home/ulauncher
    ../../home/syncthing
    ../../home/prism
    ../../home/fwedee
    ../../home/zsh
  ];

  gnocchi = {
    hypr = {
      enable = true;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
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
