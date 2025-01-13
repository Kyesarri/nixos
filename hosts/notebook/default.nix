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

    ../headless.nix

    ../../hardware
    ../../hardware/battery
    ../../hardware/bluetooth
    ../../hardware/audio

    ../../home
    ../../home/bottom
    ../../home/git
    ../../home/gtk
    ../../home/kitty
    ../../home/syncthing
    ../../home/fwedee
    ../../home/zsh
  ];

  gnocchi = {
    hypr = {
      enable = false;
      animations = false; # no config here yet #TODO - not critical - adding more mess is!
    };
    wifi.backend = "iwd";
  };

  colorscheme = inputs.nix-colors.colorSchemes.${spaghetti.scheme};

  networking.hostName = "nix-notebook";

  services.xserver.enable = true;

  environment = {
    systemPackages = with pkgs; [pciutils];
    shellAliases.rebuild = "sudo nixos-rebuild switch --flake /home/${spaghetti.user}/nixos#nix-notebook --show-trace";
  };
}
